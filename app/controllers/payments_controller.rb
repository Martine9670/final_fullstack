# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
    before_action :authenticate_user!
  
    # GET /payments/success
    def success
      appointment = current_user.appointments.find(params[:appointment_id])
      session_id = params[:session_id]
  
      # Récupération de la session Stripe réelle
      stripe_session = Stripe::Checkout::Session.retrieve(session_id)
  
      if stripe_session.payment_status == 'paid'
        appointment.update(paid: true)
        flash[:notice] = "Paiement effectué avec succès !"
      else
        flash[:alert] = "Le paiement n'a pas été confirmé."
      end
  
      redirect_to appointments_path
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = "Impossible de récupérer la session Stripe : #{e.message}"
      redirect_to appointments_path
    end
  
    # GET /payments/cancel
    def cancel
      flash[:alert] = "Paiement annulé."
      redirect_to appointments_path
    end
  end
  
  
  
  