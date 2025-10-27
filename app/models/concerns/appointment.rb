# app/models/concerns/appointment.rb

class Appointment < ApplicationRecord
  belongs_to :user

  validates :date, :start_time, :description, presence: true

  after_create :send_emails

  private

  # Envoi des mails de confirmation, sans bloquer la transaction
  def send_emails
    begin
      # Envoi au client
      UserMailer.appointment_confirmation(self).deliver_now
      # Envoi à l’admin
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


