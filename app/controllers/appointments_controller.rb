# app/controllers/appointments_controller.rb
class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  def index
    @appointments = current_user.appointments
  end

  # GET /appointments/:id
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # POST /appointments
  def create
    @appointment = current_user.appointments.build(appointment_params)

    if @appointment.save
      # Création de la session Stripe
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        mode: 'payment',
        success_url: payments_success_url + "?appointment_id=#{@appointment.id}&session_id={CHECKOUT_SESSION_ID}",
        cancel_url: payments_cancel_url,
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "Rendez-vous du #{@appointment.date.strftime('%d/%m/%Y')} à #{@appointment.time.strftime('%H:%M')}"
            },
            unit_amount: 5000, # 50 EUR en centimes
          },
          quantity: 1
        }]
      )

      # Redirection vers Stripe Checkout
      redirect_to session.url, allow_other_host: true
    else
      flash.now[:alert] = "Erreur lors de la création du rendez-vous."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /appointments/:id/edit
  def edit
  end

  # PATCH/PUT /appointments/:id
  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: "Rendez-vous mis à jour avec succès !"
    else
      flash.now[:alert] = "Erreur lors de la mise à jour du rendez-vous."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/:id
  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Rendez-vous supprimé."
  end

  private

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:date, :time)
  end
end

