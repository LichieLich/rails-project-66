# frozen_string_literal: true

class GithubRepositoryApi
  def self.client(user)
    client = Octokit::Client.new access_token: user.token, auto_paginate: true
  end

  def self.get_repository(user, id)
    client(user).repo id.to_i
  end

  def self.user_repositories(user)
    client(user).repos
  end
end