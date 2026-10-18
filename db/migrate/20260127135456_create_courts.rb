class CreateCourts < ActiveRecord::Migration[8.0]
  def change
    create_table :courts do |t|
      t.string :name
      t.string :court_type
      t.string :status
      t.text :description

      t.timestamps
    end
  end
end
