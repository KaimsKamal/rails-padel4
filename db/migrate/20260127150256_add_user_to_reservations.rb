class AddUserToReservations < ActiveRecord::Migration[8.0]
  def change
    add_reference :reservations, :user, null: true, foreign_key: true

    # Assigner le premier user aux réservations existantes
    reversible do |dir|
      dir.up do
        first_user = User.first
        if first_user
          execute "UPDATE reservations SET user_id = #{first_user.id} WHERE user_id IS NULL"
        end
      end
    end
  end
end
