# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    # TODO: Вернуть проверку на CSRF
    skip_before_action :verify_authenticity_token, only: :create

    def create
      unless params['commits']
        logger.info "Recieved a non push event by #{params['hook_id']}"
        return
      end

      @repository = Repository.find_by!(github_id: params['repository']['id'])
      user = User.find_by!(github_id: params['sender']['id'])

      @check = @repository.checks.build
      @check.commit_id = params['head_commit']['id']
      @check.start_check!
      repository_checker.perform_later(user, @check)
      @check.save
      # binding.irb

      # render status: :ok, json: @controller.to_json
      render json: {}
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
