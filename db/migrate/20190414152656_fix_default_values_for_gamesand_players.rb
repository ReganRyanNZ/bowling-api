class FixDefaultValuesForGamesandPlayers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :games, :current_turn, from: 0, to: nil
    change_column_default :games, :current_frame, from: nil, to: 0
    change_column_default :players, :score, from: nil, to: ''
  end
end
