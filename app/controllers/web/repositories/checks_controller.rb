# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    before_action :set_repository, only: %i[create show]

    def show
      @check = @repository.checks.find_by(id: params[:id])
    end

    def create
      @check = @repository.checks.build(check_params)
      @check.status = 'ZBS'
      @check.is_successful = true
      @check.commit_id = 'sdfsfsdfdsf'

      if @check.save
        redirect_to repository_url(@repository), notice: 'Check started'
      else
        redirect_to repository_url(@repository), notice: 'Check not started'
      end
    end

    private

    def check_params
      params.permit(:repository_id, :id)
    end

    def set_repository
      @repository = Repository.find_by(id: params[:repository_id])
    end
  end
end
