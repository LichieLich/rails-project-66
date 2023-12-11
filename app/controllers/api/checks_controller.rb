# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    # TODO: Вернуть проверку на CSRF
    skip_before_action :verify_authenticity_token, only: :create

    def create
      payload = JSON.parse params[:payload]

      unless payload['commits']
        logger.info "Recieved a non push event by #{payload['hook_id']}"
        return
      end

      @repository = Repository.find_by!(github_id: payload['repository']['id'])
      user = User.find_by!(github_id: payload['sender']['id'])

      @check = @repository.repository_checks.build
      @check.commit_id = payload['head_commit']['id']
      @check.start_check!
      repository_checker.perform_later(user, @check)
      @check.save
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
