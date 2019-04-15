require 'csv'

class Player < ApplicationRecord
  belongs_to :game
  validates :name, presence: true
  after_save :check_games_current_turn

  def parsed_score
    @parsed_score ||= CSV.parse(self.score).map {|frames| frames.map(&:to_i)}
  end

  def add_score frame:, new_score:
    parsed_score[frame] ||= []
    parsed_score[frame] << new_score
    self.update!(score: parsed_score.map(&:to_csv).join)
  end

  def turn_complete? frame_id
    frame = parsed_score[frame_id] || []
    if frame_id != 9
      return true if frame.sum == 10 || frame.count == 2
      return false
    else
      return true if frame.sum < 10 && frame.count == 2
      return true if frame.count == 3
      return false
    end
  end

  def check_games_current_turn
    game.update(current_turn: self.id) unless game.current_turn.present?
  end

  def total_score
    result = 0
    parsed_score.each.with_index do |frame, i|
      if frame.sum < 10
        result += frame.sum
      elsif frame[0] < 10 # spare
        result += 10 + parsed_score[i+1][0]
      else # strike
        result += 10 + parsed_score[i+1..-1].flatten[0..1].sum
      end
    end
    result
  end
end
