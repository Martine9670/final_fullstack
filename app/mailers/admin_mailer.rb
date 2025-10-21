class AdminMailer < ApplicationMailer
    default from: ENV["GMAIL_USERNAME"]
  
    def new_appointment_notification(appointment)
      @appointment = appointment
      @user = appointment.user
      @date = appointment.date.strftime("%d/%m/%Y")
      @time = appointment.time.strftime("%H:%M")
  
      admin_emails = ["admin1@monsite.fr", "admin2@monsite.fr"] # à adapter
      mail(to: admin_emails, subject: "📅 Nouveau rendez-vous pris par #{@user.name}")
    end
  end
  
  
