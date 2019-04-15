class Game < ApplicationRecord
  has_many :players

  def next_turn
    players_ids = players.pluck(:id)
    new_index = (players_ids.find_index(self.current_turn) + 1) % players_ids.count
    self.current_turn = players_ids[new_index]
    self.current_frame += 1 if new_index == 0
    save
  end

  def score
    score = {scores: {}}
    players.each do |player|
      score[:scores][player.name] = {
        frames: player.score,
        total: player.total_score
      }
    end
    score[:current_turn] = players.find { |player| player.id == current_turn}.name
    score[:current_frame] = current_frame + 1 # users should see frame numbers 1-10, instead of 0-9
    score[:game_complete] = [
      current_frame == 10,
      current_turn == players.last.id,
      players.last.turn_complete?(current_frame)
    ].all?
    score
  end
end
