# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_repository_api, -> { GithubRepositoryApiStub }
    register :repository_checker, -> { CheckRepositoryJobStub }
  else
    register :github_repository_api, -> { GithubRepositoryApi }
    register :repository_checker, -> { CheckRepositoryJob }
  end
end
