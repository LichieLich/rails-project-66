# frozen_string_literal: true

class GithubRepositoryApi
  ROUTES = Rails.application.routes.url_helpers

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

  def self.get_webhook(user, github_id)
    client(user).hooks(github_id).find { |r| r[:config][:url] == ROUTES.api_checks_url }
  end

  def self.enable_webhook(user, github_id)
    return if get_webhook(user, github_id).present?

    client(user).create_hook(
      github_id,
      'web',
      {
        url: ROUTES.api_checks_url,
        content_type: 'application/json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end

  def self.delete_webhook(user, github_id)
    webhook = get_webhook(user, github_id)
    return if webhook.blank?

    client(user).remove_hook(github_id, webhook[:id])
  end
end
