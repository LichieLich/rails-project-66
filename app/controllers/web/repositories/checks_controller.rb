# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    before_action do
      raise Pundit::NotAuthorizedError unless signed_in?
    end

    def show
      @repository = set_repository
      @check = @repository.checks.find_by(id: params[:id])

      authorize @check

      unless @check.finished?
        redirect_to repository_url(@repository), notice: t('check.create.unprepared')
        return
      end

      # TODO: Сделать паджинатор
      @errors = LinterResultsUnifier.get_linter_errors(@check)
    end

    def create
      @repository = set_repository

      @check = @repository.checks.build(check_params)
      authorize @check

      if @check.save
        # binding.irb
        CheckRepositoryJob.perform_later(@check)
        redirect_to repository_url(@repository), notice: t('check.create.success')
      else
        redirect_to repository_url(@repository), notice: t('check.create.failure')
      end
    end

    private

    def check_params
      params.permit(:repository_id)
    end

    def set_repository
      @repository = Repository.find_by(id: params[:repository_id])
    end

    def repository_checker
      ApplicationContainer[:repository_checker]
    end
  end
end
