
module Web
  class RepositoriesController < ApplicationController
    include RepositoryHelper
    before_action :set_repository, only: %i[ show edit update destroy ]
    

    # GET /repositories or /repositories.json
    def index
      @repositories = Repository.all
    end

    # GET /repositories/1 or /repositories/1.json
    def show
    end

    # GET /repositories/new
    def new
      @repository = Repository.new
      @repositories = user_repositories(current_user)
      # TODO Убрать из списка уже добавленные репы
    end

    # GET /repositories/1/edit
    def edit
    end

    # POST /repositories or /repositories.json
    def create
      repo = get_repository(current_user, params[:repository][:repository_github_id])
      @repository = current_user.repositories.build(
        repository_github_id: repo.id,
        name: repo.name,
        language: repo.language.downcase
      )

      if @repository.save
        redirect_to repository_url(@repository), notice: "Repository was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /repositories/1 or /repositories/1.json
    def update
      if @repository.update(repository_params)
        redirect_to repository_url(@repository), notice: "Repository was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /repositories/1 or /repositories/1.json
    def destroy
      @repository.destroy

      redirect_to repositories_url, notice: "Repository was successfully destroyed."
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
  end
end