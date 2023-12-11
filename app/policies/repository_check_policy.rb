# frozen_string_literal: true

class RepositoryCheckPolicy < ApplicationPolicy
  attr_reader :user, :check

  def initialize(user, check)
    super
    @user = user
    @check = check
  end

  def show?
    owner?
  end

  def create?
    user.present?
  end

  private

  def owner?
    check.repository.user_id == user&.id
  end
end
