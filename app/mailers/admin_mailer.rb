class AdminMailer < ApplicationMailer
  def new_appointment(appointment)
    @appointment = appointment
    @user = appointment.user
    @date = appointment.date ? appointment.date.strftime("%d/%m/%Y") : "non définie"
    @time = appointment.start_time ? appointment.start_time.strftime("%H:%M") : "non définie"

    mail(
      to: "final.fullstack@gmail.com",
      subject: "Nouveau rendez-vous réservé"
    )
  end

  def new_appointment_notification(appointment)
    @appointment = appointment
    @user = appointment.user
    @date = appointment.date ? appointment.date.strftime("%d/%m/%Y") : "non définie"
    @time = appointment.start_time ? appointment.start_time.strftime("%H:%M") : "non définie"

    mail(
      to: "final.fullstack@gmail.com",
      subject: "Nouveau rendez-vous réservé",
      template_name: "new_appointment"
    )
  end
end
