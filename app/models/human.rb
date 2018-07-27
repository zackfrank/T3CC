class Human < ApplicationRecord
  belongs_to :game
  validates :game, presence: false

  def set_symbol(symbol)
    self.symbol = symbol
  end

  def make_move
    self.symbol
  end

end