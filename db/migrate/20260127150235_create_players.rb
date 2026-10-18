class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :position
      t.string :name

      t.timestamps
    end
  end
end
