class AddStartTimeToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :appointments, :start_time, :datetime
  end
end
