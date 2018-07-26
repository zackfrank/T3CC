class Human < ApplicationRecord
 
  def initialize
    @hum
  end

  def set_symbol(symbol)
    @hum = symbol
  end

  def make_move
    @hum
  end
  
end