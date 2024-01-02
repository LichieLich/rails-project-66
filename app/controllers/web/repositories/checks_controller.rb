# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    before_action do
      raise Pundit::NotAuthorizedError unless current_user.present?
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
      @errors = JSON.parse(@check.linter_result) unless @check.linter_result.empty?
    end

    def create
      @repository = set_repository

      @check = @repository.checks.build(check_params)
      authorize @check
      # @check.start_check!
      # binding.irb
      # repository_checker.perform_later(current_user, @check)

      if @check.save
        # binding.irb
        repository_checker.perform_later(current_user, @check)
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
