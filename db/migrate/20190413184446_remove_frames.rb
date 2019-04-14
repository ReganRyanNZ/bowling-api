class RemoveFrames < ActiveRecord::Migration[5.2]
  def change
    drop_table :frames do |t|
      t.references :player, foreign_key: true
      t.references :game, foreign_key: true
      t.integer :ball_one
      t.integer :ball_two
      t.integer :ball_three

      t.timestamps
    end
  end
end
