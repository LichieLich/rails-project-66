# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :set_repository, only: %i[show edit destroy]
    before_action only: %i[index new create] do
      authorize Repository
    end

    def index
      @repositories = Repository.where(user_id: current_user.id)
    end

    def show
      authorize @repository

      # TODO: автообновление таблицы при изменении статуса
      @checks = @repository.checks.order(created_at: :desc)
    end

    def new
      @repository = Repository.new
      @repositories = repositories_available_to_connect
    end

    def create
      # TODO: Добавить возможность не подписываться на уведомления по почте

      @repository = current_user.repositories.build(github_id: params[:repository][:github_id])

      if @repository.save
        Github::GetRepositoryJob.perform_later(@repository)
        redirect_to repository_url(@repository), notice: t('repositories.create.success')
      else
        @repositories = repositories_available_to_connect
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @repository

      Github::DisableWebhookJob.perform_later(@repository)
      @repository.destroy

      redirect_to repositories_url, notice: t('repositories.destroy.success')
    end

    private

    def set_repository
      @repository = Repository.find(params[:id])
    end

    def repository_params
      params.require(:repository).permit(:github_id, :language, :name, :user_id)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end

    def repositories_available_to_connect
      github_repository_api.user_repositories(current_user)&.reject do |repo|
        Repository.find_by(github_id: repo.id) || Repository.language.values.exclude?(repo.language&.downcase)
      end
    end
  end
end
