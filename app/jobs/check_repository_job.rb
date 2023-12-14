# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  include CheckHelper

  def perform(user, check)
    repository_directory = "tmp/repositories/#{check.repository.name}"
    begin
      check.commit_id = github_repository_api.get_last_commit(user, check.repository.github_id)
      check.got_repository_data!
    rescue StandardError => e
      check.fail_get_repository!
      raise e
    end

    begin
      BashRunner.run("rm -r -f #{repository_directory}")
      BashRunner.run('mkdir tmp/repositories')
      BashRunner.run("git clone #{check.repository.git_url} #{repository_directory}")
    rescue StandardError => e
      check.fail_clone!
      send_complete_notification(user, check)
      raise e
    end

    check.finish_cloning_repository!

    case check.repository.language.downcase
    when 'javascript'
      check.linter_result = BashRunner.run("npx eslint #{repository_directory}/**/*.js --format json")
    when 'ruby'
      check.linter_result = BashRunner.run("rubocop #{repository_directory} --format json")
    else
      send_complete_notification(user, check)
      raise "#{check.repository.language} не поддерживается"
    end

    check.passed = check_has_no_problems?(check)
    check.finish_check!

    BashRunner.run("rm -r -f #{repository_directory}")
    send_complete_notification(user, check) unless check_has_no_problems?(check)
  end

  def github_repository_api
    ApplicationContainer[:github_repository_api]
  end
end
