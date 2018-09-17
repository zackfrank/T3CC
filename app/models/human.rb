class Human < ApplicationRecord
  belongs_to :game, required: false
  validates :name, presence: false
  validates :symbol, presence: false

  def as_json
    {
      id: id,
      game_id: game_id,
      name: name,
      symbol: symbol,
      player_type: "Human"
    }
  end

end