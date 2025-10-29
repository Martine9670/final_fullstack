class StripeWebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def receive
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
  
      event = nil
  
      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError => e
        render json: { error: "Invalid payload" }, status: 400 and return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: "Invalid signature" }, status: 400 and return
      end
  
      case event.type
      when 'checkout.session.completed'
        session = event.data.object
        appointment = Appointment.find_by(id: session.metadata.appointment_id)
        appointment.update(paid: true) if appointment
      end
  
      render json: { message: 'success' }
    end
  end
  