# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks
  enumerize :language, in: [:javascript]
end
