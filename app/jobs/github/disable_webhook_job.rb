# frozen_string_literal: true

module Github
  class DisableWebhookJob < ApplicationJob
    queue_as :default

    def perform(user, github_id)
      github_repository_api.delete_webhook(user, github_id)
    end

    def github_repository_api
      ApplicationContainer[:github_repository_api]
    end
  end
end
