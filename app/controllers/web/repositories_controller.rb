# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :set_repository, only: %i[show edit destroy]
    before_action only: %i[index new create] do
      authorize Repository
    end

    # GET /repositories or /repositories.json
    def index
      @repositories = Repository.all
    end

    # GET /repositories/1 or /repositories/1.json
    def show
      authorize @repository

      @checks = @repository.checks
      @repository_data = github_repository_api.get_repository(current_user, @repository.repository_github_id)
    end

    # GET /repositories/new
    def new
      @repository = Repository.new
      @repositories = github_repository_api.user_repositories(current_user)
      # TODO: Убрать из списка уже добавленные репы
    end

    # GET /repositories/1/edit
    def edit
      authorize @repository
    end

    # POST /repositories or /repositories.json
    def create
      repository_data = github_repository_api.get_repository(current_user, params[:repository][:repository_github_id])
      @repository = current_user.repositories.build(
        repository_github_id: repository_data.id,
        name: repository_data.name,
        language: repository_data.language&.downcase
      )

      # TODO: Сделать подписку на вебхуки опциональной при создании репы
      github_repository_api.enable_webhook(current_user, repository_data.full_name)

      if @repository.save
        redirect_to repository_url(@repository), notice: t('repositories.create.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    # DELETE /repositories/1 or /repositories/1.json
    def destroy
      authorize @repository

      @repository.destroy
      github_repository_api.delete_webhook(current_user, @repository)

      redirect_to repositories_url, notice: t('repositories.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def repository_params
      params.require(:repository).permit(:repository_github_id, :language, :name, :user_id)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
