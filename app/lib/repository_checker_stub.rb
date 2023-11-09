# frozen_string_literal: true

class RepositoryCheckerStub
  def self.perform_check(check, _repository_data)
    check.finish_cloning_repository!
  end
end
