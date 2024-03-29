# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm whiny_transitions: false do
    state :not_checked, initial: true
    state :getting_repository_data
    state :cloning_repository
    state :linter_in_progress
    state :finished
    state :failed_clone
    state :failed_get_repository
    state :linter_failed

    event :start_check do
      transitions from: :not_checked, to: :getting_repository_data
    end

    event :got_repository_data do
      transitions from: :getting_repository_data, to: :cloning_repository
    end

    event :finish_cloning_repository do
      transitions from: :cloning_repository, to: :linter_in_progress
    end

    event :finish_check do
      transitions from: :linter_in_progress, to: :finished
    end

    event :fail_clone do
      transitions from: :cloning_repository, to: :failed_clone
    end

    event :fail_get_repository do
      transitions from: :getting_repository_data, to: :failed_get_repository
    end

    event :fail_linting do
      transitions from: :linter_in_progress, to: :linter_failed
    end
  end
end
