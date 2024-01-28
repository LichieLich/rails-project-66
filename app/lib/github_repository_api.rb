# frozen_string_literal: true

class GithubRepositoryApi
  @@routes = Rails.application.routes.url_helpers

  def self.client(user)
    Octokit::Client.new access_token: user.token, auto_paginate: true
  end

  def self.get_repository(user, id)
    client(user).repo id.to_i
  end

  def self.user_repositories(user)
    client(user).repos
  end

  def self.get_last_commit(user, id)
    client(user).commits(id).first[:sha].to_s
  end

  def self.enable_webhook(user, full_name)
    client(user).create_hook(
      full_name,
      'web',
      {
        url: @@routes.api_checks_url,
        content_type: 'application/json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end

  def self.delete_webhook(user, github_id)
    hooks = client(user).hooks(github_id)
    webhook = hooks.select { |r| r[:config][:url] ==  @@routes.api_checks_url }
    client(user).remove_hook(github_id, webhook.first[:id]) unless webhook.first.nil?
  end
end
