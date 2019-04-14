class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :current_turn, default: 0
      t.timestamps
    end
  end
end
