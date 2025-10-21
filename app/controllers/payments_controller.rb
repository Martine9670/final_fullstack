# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  before_action :authenticate_user!

  # POST /payments
  def create
    # 💡 Ici, on récupère le rendez-vous à payer.
    # Adapte selon ton cas (dernier rendez-vous, ou choisi dans un formulaire)
    appointment = current_user.appointments.last

    # ⚙️ Création de la session Stripe Checkout
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: { name: "Rendez-vous médical" },
          unit_amount: 2000 # Montant en centimes : ici 20,00 €
        },
        quantity: 1
      }],
      # ✅ URLs de redirection après paiement
      success_url: success_payments_url(appointment_id: appointment.id) + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: cancel_payments_url
    )
    # 🚀 Redirection vers la page de paiement Stripe
    redirect_to session.url, allow_other_host: true

  rescue Stripe::InvalidRequestError => e
    flash[:alert] = "Erreur Stripe : #{e.message}"
    redirect_to appointments_path
  end

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
 
  
  
  