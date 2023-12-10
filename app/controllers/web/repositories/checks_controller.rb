# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    include CheckHelper
    before_action :set_repository, only: %i[create show]

    def show
      @check = @repository.checks.find_by(id: params[:id])

      authorize @check

      unless @check.finished?
        redirect_to repository_url(@repository), notice: t('check.create.unprepared')
        return
      end

      @errors = JSON.parse(@check.linter_result)
      @repository_data = github_repository_api.get_repository(current_user, @repository.repository_github_id)
    end

    def create
      "asdsa"
      # TODO: Закинуть длинные вещи в бэкграунд. Тут или внутри класса
      # TODO: BashRUnner не рабоатет на проде
      authorize Check

      @check = @repository.checks.build(check_params)
      @check.commit_id = github_repository_api.get_last_commit(current_user, @repository.repository_github_id)
      @check.start_check!

      repository_checker.perform_later(current_user, @check)

      if @check.save
        # TODO: Добавить возможность отписки
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
