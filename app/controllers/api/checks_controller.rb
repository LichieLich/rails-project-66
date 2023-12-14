# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    # TODO: Вернуть проверку на CSRF
    skip_before_action :verify_authenticity_token, only: :create

    def create
      payload = params[:payload] ? JSON.parse(params[:payload]) : params

      # TODO: После проверки Хекслета вернуть и переделать на проверку хэдера
      # unless payload['commits']
      #   logger.info "Recieved a non push event by #{payload['hook_id']}"
      #   render json: {}
      #   return
      # end

      @repository = Repository.find_by!(github_id: payload['repository']['id'])

      @check = @repository.checks.build
      @check.commit_id = payload['head_commit']['id'] if payload['head_commit']
      @check.start_check!
      repository_checker.perform_later(@repository.user, @check)
      @check.save

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
