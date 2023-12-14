# frozen_string_literal: true

module Github
  class EnableWebhookJob < ApplicationJob
    queue_as :default

    def perform(repository)
      github_repository_api.enable_webhook(repository.user, repository.full_name)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
