# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_repository_api, -> { GithubRepositoryApiStub }
  else
    register :github_repository_api, -> { GithubRepositoryApi }
  end
end
