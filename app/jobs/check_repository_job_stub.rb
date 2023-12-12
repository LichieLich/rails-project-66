# frozen_string_literal: true

class CheckRepositoryJobStub < ApplicationJob
  queue_as :default

  def perform(_user, check)
    check.got_repository_data!
    check.finish_cloning_repository!
    check.passed = true
    check.finish_check!
  end
end
