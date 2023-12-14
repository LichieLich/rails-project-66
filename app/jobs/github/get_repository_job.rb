# frozen_string_literal: true

module Github
  class GetRepositoryJob < ApplicationJob
    queue_as :default

    def perform(repository)
      repository_data = github_repository_api.get_repository(repository.user, repository.github_id)

      repository.name = repository_data.name
      repository.full_name = repository_data.full_name
      repository.language = repository_data.language.downcase
      repository.git_url = repository_data.clone_url
      repository.ssh_url = repository_data.ssh_url
      repository.save

      Github::EnableWebhookJob.perform_later(repository)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
