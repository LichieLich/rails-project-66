# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    # TODO: Вернуть проверку на CSRF
    skip_before_action :verify_authenticity_token, only: :create

    def create
      payload = params[:payload] ? JSON.parse(params[:payload]) : params

      # TODO: После проверки Хекслета вернуть и переделать на проверку хэдера
      # unless request.headers['X-GitHub-Event'] == 'push'
      #   logger.info "Recieved a non push event by #{payload['hook_id']}"
      #   head :ok
      #   return
      # end

      @repository = Repository.find_by!(github_id: payload['repository']['id'])

      @check = @repository.checks.build
      @check.commit_id = payload['head_commit']['id'] if payload['head_commit']
      @check.start_check!
      CheckRepositoryJob.perform_later(@check)
      @check.save

      head :ok
    end

    private

    def repository_checker
      ApplicationContainer[:repository_checker]
    end
  end
end
