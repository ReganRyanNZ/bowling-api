class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
