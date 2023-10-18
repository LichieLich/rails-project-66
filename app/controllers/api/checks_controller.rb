module Api
  class ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = JSON.parse params[:payload]

      unless payload['commits']
        logger.info "Recieved a non push event by #{payload['hook_id']}"
        return
      end

      @repository = Repository.find_by!(repository_github_id: payload['repository']['id'])

      @check = @repository.checks.build
      @check.commit_id = payload['head_commit']['id']
      @check.save

      @check.start_check!

      @check.got_repository_data!
      @check.linter_result = repository_checker.perform_check(@check, payload['repository'])

      @check.finish_check!
    end
  end
end