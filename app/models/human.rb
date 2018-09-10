class Human < ApplicationRecord
  belongs_to :game
  validates :game, presence: false
end