# frozen_string_literal: true

module Web::Repositories
  class ChecksController < ApplicationController
    before_action :set_repository, only: %i[create show]

    def show
      @check = @repository.checks.find_by(id: params[:id])
      @errors = @check.linter_result.split("\n").each_with_object([]) do |line, arr| 
        next if line.empty?
        arr << line.split(/\s{2,}/)
      end
      
      redirect_to repository_url(@repository) unless @check.finished?
    end

    def create
      @check = @repository.checks.build(check_params)
      @check.start_check!

      begin
        repository_data = github_repository_api.get_repository(current_user, @repository.repository_github_id)
      rescue => e
        @check.fail_get_repository!
        raise e
      end

      @check.got_repository_data!
      check_result = repository_checker.perform_check(@check, repository_data)
      # @check.commit_id = repository_data

      @check.finish_check!

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

    def repository_checker
      ApplicationContainer[:repository_checker]
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
