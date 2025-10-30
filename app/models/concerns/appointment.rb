class Appointment < ApplicationRecord
  belongs_to :user

  validates :date, :start_time, :description, presence: true
  validate :date_cannot_be_in_the_past
  validate :time_cannot_be_in_the_past_if_today

  after_create :send_emails

  private

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "cannot be in the past")
    end
  end

  def time_cannot_be_in_the_past_if_today
    return unless date.present? && start_time.present?

    if date == Date.today && start_time < Time.current
      errors.add(:start_time, "cannot be in the past for today")
    end
  end

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
      Rails.logger.error "❌ General mail error: #{e.message}"
    end
  end
end
