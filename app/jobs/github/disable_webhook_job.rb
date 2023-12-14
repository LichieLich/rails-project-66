# frozen_string_literal: true

module Github
  class DisableWebhookJob < ApplicationJob
    queue_as :default

    def perform(repository)
      github_repository_api.delete_webhook(repository.user, repository.id)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
