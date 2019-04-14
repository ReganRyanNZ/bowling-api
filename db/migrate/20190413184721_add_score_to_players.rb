class AddScoreToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :score, :text
  end
end
