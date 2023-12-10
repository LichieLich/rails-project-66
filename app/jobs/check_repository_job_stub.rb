# frozen_string_literal: true

class CheckRepositoryJobStub < ApplicationJob
  queue_as :default

  def perform(_user, check)
    check.finish_check!
  end
end
