# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  attr_reader :user, :repository

  def initialize(user, repository)
    super
    @user = user
    @repository = repository
  end

  def show?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    repository.user_id == user&.id
  end
end
