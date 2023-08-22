# frozen_string_literal: true

class Check < ApplicationRecord
  belongs_to :repository

  aasm whiny_transitions: false, column: :status do
    state :not_checked, initial: true, display: 'Not checked'
    state :in_progress, display: 'IP'
    state :checked, display: 'Checked'

    event :perform_check do
      transitions from: :not_checked, to: :in_progress
    end

    event :finish_check do
      transitions from: :in_progress, to: :checked
    end
  end
end
