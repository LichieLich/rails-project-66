# frozen_string_literal: true

class GithubRepositoryApi
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

  def self.enable_webhook(user, name)
    client(user).create_hook(
      name,
      'web',
      {
        url: "https://#{ENV.fetch('BASE_URL', nil)}/api/checks",
        content_type: 'application/json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end

  def self.delete_webhook(user, id)
    hooks = client(user).hooks(id)
    webhook = hooks.select { |r| r[:config][:url] == "https://#{ENV.fetch('BASE_URL', nil)}/api/checks" }
    client(user).remove_hook(id, webhook.first[:id]) unless webhook.first.nil?
  end
end
