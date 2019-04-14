class Player < ApplicationRecord
  belongs_to :game
  validates :name, presence: true

  def parsed_score
    CSV.parse(self.score).map {|frames| frames.map(&:to_i)}
  end
end
