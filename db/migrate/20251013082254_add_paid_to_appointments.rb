class AddPaidToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :appointments, :paid, :boolean
  end
end
