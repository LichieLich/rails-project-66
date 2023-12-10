# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  include CheckHelper

  def perform(user, check)
    begin
      repository_data = github_repository_api.get_repository(user, check.repository.repository_github_id)
    rescue StandardError => e
      check.fail_get_repository!
      raise e
    end

    check.got_repository_data!
    repository_directory = "tmp/repositories/#{repository_data.name}"

    begin
      BashRunner.run("rm -r -f #{repository_directory}")
      BashRunner.run('mkdir tmp/repositories')
      BashRunner.run("git clone #{repository_data.clone_url} #{repository_directory}")
    rescue StandardError => e
      check.fail_clone!
      send_complete_notification(user, check)
      raise e
    end

    check.finish_cloning_repository!

    case repository_data.language.downcase
    when 'javascript'
      check.linter_result = BashRunner.run("npx eslint #{repository_directory}/**/*.js --format json")
    when 'ruby'
      check.linter_result = BashRunner.run("rubocop #{repository_directory} --format json")
    else
      send_complete_notification(user, check)
      raise "#{repository_data.language} не поддерживается"
    end

    check.finish_check!
    send_complete_notification(user, check) unless check_has_no_problems?(check)
  end

  def github_repository_api
    ApplicationContainer[:github_repository_api]
  end
end
