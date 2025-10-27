class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :require_admin, only: [:update_status]

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
      # Mail + Stripe...
      redirect_to @appointment, notice: "Rendez-vous créé ✅"
    else
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
  def update_status
    new_status = params[:status]

    if @appointment.update(status: new_status)
      redirect_to admin_dashboard_path, notice: "Statut mis à jour ✅"
    else
      redirect_to admin_dashboard_path, alert: "Erreur lors de la mise à jour ❌"
    end
  end

  private

  def set_appointment
    # ⚠️ Pour l’admin, on veut accéder à tous les rendez-vous, pas seulement les siens
    @appointment = current_user.admin? ? Appointment.find(params[:id]) : current_user.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:date, :start_time)
  end

  def require_admin
    redirect_to root_path, alert: "Accès réservé aux administrateurs 🚫" unless current_user.admin?
  end
end
