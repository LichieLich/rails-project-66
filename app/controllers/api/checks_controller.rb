# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    include CheckHelper
    # TODO: Вернуть проверку на CSRF
    skip_before_action :verify_authenticity_token, only: :create

    def create
      payload = JSON.parse params[:payload]

      unless payload['commits']
        logger.info "Recieved a non push event by #{payload['hook_id']}"
        return
      end

      @repository = Repository.find_by!(repository_github_id: payload['repository']['id'])
      user = User.find_by!(github_id: payload['sender']['id'])

      @check = @repository.checks.build
      @check.commit_id = payload['head_commit']['id']

      @check.start_check!

      begin
        repository_data = github_repository_api.get_repository(user, @repository.repository_github_id)
      rescue StandardError => e
        @check.fail_get_repository!
        raise e
      end

      @check.got_repository_data!
      @check.linter_result = repository_checker.perform_check(@check, repository_data)
      @check.finish_check! if @check.save

      send_complete_notification(user, @check)
    end

    private

    def repository_checker
      ApplicationContainer[:repository_checker]
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
