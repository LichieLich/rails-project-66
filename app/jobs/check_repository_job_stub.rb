# frozen_string_literal: true

class CheckRepositoryJobStub < ApplicationJob
  queue_as :default

  def perform(_user, check)
    check.start_check!
    check.commit_id = '1234'
    check.got_repository_data!
    check.finish_cloning_repository!
    check.passed = true
    check.errors_count = 0
    check.save
    check.finish_check!
  end
end
