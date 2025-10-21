class UserMailer < ApplicationMailer
  def appointment_confirmation(appointment)
    @appointment = appointment
    @user = @appointment.user
    mail(to: @user.email, subject: "Confirmation de votre rendez-vous")
  end
end

  
  
  
  
  
  
