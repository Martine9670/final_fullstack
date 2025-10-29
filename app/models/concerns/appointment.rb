class Appointment < ApplicationRecord
  belongs_to :user

  validates :date, :start_time, :description, presence: true

  after_create :send_emails

  private

  # Email confirmation
  def send_emails
    begin
      # User
      UserMailer.appointment_confirmation(self).deliver_now
      # Admin
      AdminMailer.new_appointment_notification(self).deliver_now
    rescue Net::SMTPAuthenticationError => e
      Rails.logger.error "❌ SMTP Auth error: #{e.message}"
    rescue Net::SMTPFatalError, Net::SMTPSyntaxError => e
      Rails.logger.error "❌ SMTP delivery error: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "❌ Erreur générale d’envoi de mail: #{e.message}"
    end
  end
end


