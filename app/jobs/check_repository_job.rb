# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(user, check)
    check.start_check!
    repository_directory = "tmp/repositories/#{check.repository.name}"

    begin
      check.commit_id = github_repository_api.get_last_commit(user, check.repository.github_id)
      check.got_repository_data!
    rescue StandardError => e
      check.fail_get_repository!
      raise e
    end

    begin
      bash_runner.run("rm -r -f #{repository_directory}")
      bash_runner.run('mkdir tmp/repositories')
      bash_runner.run("git clone #{check.repository.git_url} #{repository_directory}")
    rescue StandardError => e
      check.fail_clone!
      send_complete_notification(user, check)
      raise e
    end

    check.finish_cloning_repository!

    case check.repository.language.downcase
    when 'javascript'
      check.linter_result = bash_runner.run("npx eslint #{repository_directory}/**/*.js --format json")
    when 'ruby'
      check.linter_result = bash_runner.run("rubocop #{repository_directory} --format json")
    else
      send_complete_notification(user, check)
      raise "#{check.repository.language} не поддерживается"
    end

    check.errors_count = problems_count(check)
    check.passed = check.errors_count.zero?
    check.finish_check!

    bash_runner.run("rm -r -f #{repository_directory}")
    send_complete_notification(user, check) unless check.passed
  end

  def send_complete_notification(user, check)
    check_notification_mailer.with(
      user:,
      check:
    ).check_notification.deliver_later
  end

  def problems_count(check)
    return 0 unless check.linter_result

    case check.repository.language
    when 'ruby'
      JSON.parse(check.linter_result)['summary']['offense_count']
    when 'javascript'
      error_count = 0
      JSON.parse(check.linter_result).each { |error| error_count += error['errorCount'] }
      error_count
    end
  end

  def github_repository_api
    ApplicationContainer[:github_repository_api]
  end

  def bash_runner
    ApplicationContainer[:bash_runner]
  end

  def check_notification_mailer
    ApplicationContainer[:check_notification_mailer]
  end
end
