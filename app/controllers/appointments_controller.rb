class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :require_admin, only: [:update_status]

  # GET /appointments
  def index
    @appointments = current_user.admin? ? Appointment.all : current_user.appointments
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
    @appointment.status = "pending"

    if @appointment.save
      # ✅ Debug 
      Rails.logger.info "Rendez-vous créé avec ID #{@appointment.id}"

      # 🔹 start_time for Stripe
      start_time_str = @appointment.start_time ? @appointment.start_time.strftime("%H:%M") : "heure non définie"

      # 🔹 Create session Stripe
      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        mode: 'payment',
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "Rendez-vous du #{@appointment.date.strftime('%d/%m/%Y')} à #{start_time_str}"
            },
            unit_amount: 5000 # 50 EUR
          },
          quantity: 1
        }],
        success_url: success_payments_url(appointment_id: @appointment.id) + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: cancel_payments_url
      )

      # 🔹 Redirect Stripe
      redirect_to stripe_session.url, allow_other_host: true

    else
      # ❌ Log error for debug
      Rails.logger.error "Erreur création RDV : #{@appointment.errors.full_messages.join(', ')}"
      flash.now[:alert] = "Impossible de créer le rendez-vous : #{@appointment.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end


  # GET /appointments/:id/edit
  def edit
  end

  # PATCH/PUT /appointments/:id
  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: "Rendez-vous mis à jour ✅"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/:id
  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Rendez-vous supprimé ✅"
  end

  # PATCH /appointments/:id/update_status
  # Only for admins
  def update_status
    if @appointment.update(status: params[:status])
      redirect_to admin_dashboard_path, notice: "Statut mis à jour ✅"
    else
      redirect_to admin_dashboard_path, alert: "Erreur lors de la mise à jour ❌"
    end
  end

  private

  def set_appointment
    @appointment = current_user.admin? ? Appointment.find(params[:id]) : current_user.appointments.find(params[:id])
  end

  # ⚡ Strong params
  def appointment_params
    params.require(:appointment).permit(:date, :start_time, :description)
  end

  def require_admin
    redirect_to root_path, alert: "Accès réservé aux administrateurs 🚫" unless current_user.admin?
  end
end
