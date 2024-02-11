# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_repository_api, -> { GithubRepositoryApiStub }
    register :bash_runner, -> { BashRunnerStub }
  else
    register :github_repository_api, -> { GithubRepositoryApi }
    register :bash_runner, -> { BashRunner }
  end
end
