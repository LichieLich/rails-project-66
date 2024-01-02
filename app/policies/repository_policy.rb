# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  attr_reader :user, :repository

  def initialize(user, repository)
    super
    @user = user
    @repository = repository
  end

  def index?
    user.present?
  end

  def new?
    user.present?
  end

  def show?
    owner?
  end

  def create?
    user.present?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    repository.user_id == user&.id
  end
end
