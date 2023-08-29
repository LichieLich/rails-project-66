# frozen_string_literal: true

class Check < ApplicationRecord
  include AASM

  belongs_to :repository

  # attribute :linter_result, default: -> { 'No checks yet' }

  aasm whiny_transitions: false, column: :status do
    state :not_checked, initial: true, display: 'Not checked'
    state :getting_repository_data, display: 'get rp data'
    state :cloning_repository, display: 'cloning'
    state :linter_in_progress, display: 'linter ip'
    state :finished, display: 'Checked'
    state :failed_clone, display: 'failed cloning'
    state :failed_get_repository, display: 'failed get repo'

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
  end
end
