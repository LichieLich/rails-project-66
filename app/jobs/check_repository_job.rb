# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  LINTER_COMMANDS = {
    'javascript' => 'npx eslint <%=repository_directory%>/**/*.js --format json -c .eslintrc.yml',
    'ruby' => 'rubocop <%=repository_directory%> --format json -c .rubocop.yml'
  }.freeze

  def perform(check)
    check.start_check!
    repository_directory = "tmp/repositories/#{check.repository.github_id}"

    begin
      check.commit_id = github_repository_api.get_last_commit(check.repository.user, check.repository.github_id)
      check.got_repository_data!
    rescue StandardError => e
      check.fail_get_repository!
      raise e
    end

    begin
      bash_runner.run("git clone #{check.repository.git_url} #{repository_directory}")
    rescue StandardError => e
      check.fail_clone!
      send_complete_notification(check)
      raise e
    end

    check.finish_cloning_repository!

    begin
      check.linter_result = bash_runner.run(ERB.new(LINTER_COMMANDS[check.repository.language.downcase]).result(binding)) || ''

      check.errors_count = problems_count(check)
      check.passed = check.errors_count.zero?
      check.finish_check!
    rescue StandardError => _e
      check.linter_result = ''
      check.fail_linting!
    ensure
      bash_runner.run("rm -r -f #{repository_directory}")
      send_complete_notification(check) unless check.passed
    end
  end

  def send_complete_notification(check)
    CheckNotificationMailer.with(
      user: check.repository.user,
      check:
    ).check_notification.deliver_later
  end

  def problems_count(check)
    return 0 if check.linter_result.empty?

    case check.repository.language
    when 'ruby'
      JSON.parse(check.linter_result)['summary']['offense_count']
    when 'javascript'
      JSON.parse(check.linter_result).sum { |error| error['errorCount'] }
    end
  end

  def github_repository_api
    ApplicationContainer[:github_repository_api]
  end

  def bash_runner
    ApplicationContainer[:bash_runner]
  end
end
