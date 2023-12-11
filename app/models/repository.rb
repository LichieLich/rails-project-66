# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :repository_checks, dependent: :destroy
  validates :language, presence: true
  enumerize :language, in: %i[javascript ruby]
end
