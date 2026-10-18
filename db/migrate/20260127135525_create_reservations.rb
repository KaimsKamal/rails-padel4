class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :court, null: false, foreign_key: true
      t.date :reservation_date
      t.time :start_time
      t.time :end_time
      t.string :customer_name
      t.string :customer_email
      t.string :customer_phone
      t.string :status

      t.timestamps
    end
  end
end
