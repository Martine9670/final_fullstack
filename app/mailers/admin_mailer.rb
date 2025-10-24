# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  def new_appointment(appointment)
    @appointment = appointment
    @user = appointment.user
    @date = appointment.date.strftime("%d/%m/%Y")
    @time = appointment.time.strftime("%H:%M")

    mail(
      to: "final.fullstack@gmail.com",
      subject: "Nouveau rendez-vous réservé"
    )
  end

  # 🔄 Compatibilité avec l'ancien nom, en réutilisant explicitement le bon template
  def new_appointment_notification(appointment)
    @appointment = appointment
    @user = appointment.user
    @date = appointment.date.strftime("%d/%m/%Y")
    @time = appointment.time.strftime("%H:%M")

    mail(
      to: "final.fullstack@gmail.com",
      subject: "Nouveau rendez-vous réservé",
      template_name: "new_appointment" # 👈 forcer le bon template ici
    )
  end
end

