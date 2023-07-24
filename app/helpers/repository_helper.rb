# frozen_string_literal: true

module RepositoryHelper
  def get_repository(user, id)
    client = Octokit::Client.new access_token: user.token, auto_paginate: true
    @@client
    client.repo id.to_i
  end

  def user_repositories(user)
    client = Octokit::Client.new access_token: user.token, auto_paginate: true
    @@client
    client.repos
  end
end