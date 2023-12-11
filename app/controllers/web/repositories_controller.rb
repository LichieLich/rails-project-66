# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :set_repository, only: %i[show edit destroy]
    before_action only: %i[index new create] do
      authorize Repository
    end

    def index
      @repositories = Repository.all
    end

    def show
      authorize @repository

      # TODO: автообновление таблицы при изменении статуса
      @checks = @repository.repository_checks.order(created_at: :desc)
      @repository_data = github_repository_api.get_repository(current_user, @repository.github_id)
    end

    def new
      @repository = Repository.new
      @repositories = github_repository_api.user_repositories(current_user)&.reject do |repo|
        Repository.find_by(github_id: repo.id) || Repository.language.values.exclude?(repo.language&.downcase)
      end
    end

    def edit
      authorize @repository
      # TODO: Добавить возможность отписки
    end

    def create
      # TODO: Добавить возможность не подписываться на уведомления по почте
      repository_data = github_repository_api.get_repository(current_user, params[:repository][:github_id])
      @repository = current_user.repositories.build(
        github_id: repository_data.id,
        name: repository_data.name,
        full_name: repository_data.full_name,
        language: repository_data.language&.downcase
      )

      github_repository_api.enable_webhook(current_user, repository_data.full_name)

      if @repository.save
        redirect_to repository_url(@repository), notice: t('repositories.create.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @repository

      @repository.destroy
      github_repository_api.delete_webhook(current_user, @repository.github_id)

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
  end
end
