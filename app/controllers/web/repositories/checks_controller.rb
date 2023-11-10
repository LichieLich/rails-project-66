# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    include CheckHelper
    before_action :set_repository, only: %i[create show]

    def show
      @check = @repository.checks.find_by(id: params[:id])

      authorize @check

      @errors = JSON.parse(@check.linter_result)
      @repository_data = github_repository_api.get_repository(current_user, @repository.repository_github_id)

      redirect_to repository_url(@repository) unless @check.finished?
    end

    def create
      # TODO: Закинуть длинные вещи в бэкграунд. Тут или внутри класса
      # TODO: BashRUnner не рабоатет на проде
      authorize Check

      @check = @repository.checks.build(check_params)
      @check.commit_id = github_repository_api.get_last_commit(current_user, @repository.repository_github_id)
      @check.start_check!

      begin
        repository_data = github_repository_api.get_repository(current_user, @repository.repository_github_id)
      rescue StandardError => e
        @check.fail_get_repository!
        raise e
      end

      @check.got_repository_data!
      @check.linter_result = repository_checker.perform_check(@check, repository_data)
      logger.info '!!!!!------------!!!!!!'
      logger.info Rails.env
      logger.info @check.linter_result

      if @check.save
        # TODO: Добавить возможность отписки
        @check.finish_check!
        send_complete_notification(current_user, @check)
        redirect_to repository_url(@repository), notice: t('check.create.success')
      else
        redirect_to repository_url(@repository), notice: t('check.create.failure')
      end
    end

    private

    def check_params
      params.permit(:repository_id, :id)
    end

    def set_repository
      @repository = Repository.find_by(id: params[:repository_id])
    end

    def repository_checker
      ApplicationContainer[:repository_checker]
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
