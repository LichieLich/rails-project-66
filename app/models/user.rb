# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true

  has_many :repositories, dependent: :destroy
end
