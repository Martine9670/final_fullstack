class ReplaceTimeWithStartTimeInAppointments < ActiveRecord::Migration[8.0]
  def change
    remove_column :appointments, :time
    add_column :appointments, :start_time, :datetime
  end
end
