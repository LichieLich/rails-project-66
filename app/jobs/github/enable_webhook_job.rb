# frozen_string_literal: true

module Github
  class EnableWebhookJob < ApplicationJob
    queue_as :default

    def perform(repository)
      github_repository_api.enable_webhook(repository.user, repository.github_id)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
