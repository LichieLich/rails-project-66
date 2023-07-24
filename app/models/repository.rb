class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  enumerize :language, in: [:javascript]
end
