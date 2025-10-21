class Appointment < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :time, presence: true

  after_create :send_emails

  private

  def send_emails
    UserMailer.appointment_confirmation(self).deliver_now
    AdminMailer.new_appointment_notification(self).deliver_now
  end
end

