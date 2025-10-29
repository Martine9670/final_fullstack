class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
    @appointments = Appointment.all.order(date: :asc, start_time: :asc)
    # Stats
    @total_users = User.count
    @total_admins = User.where(admin: true).count
    @total_appointments = Appointment.count
  end

  # Toggle admin / non-admin
  def toggle_admin
    user = User.find(params[:id])

    if user != current_user
      user.update(admin: !user.admin?)
      status = user.admin? ? "admin 👑" : "simple utilisateur"
      redirect_to admin_dashboard_path, notice: "#{user.email} est maintenant #{status}"
    else
      redirect_to admin_dashboard_path, alert: "Vous ne pouvez pas modifier vos propres droits."
    end
  end

  private

  def check_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Accès réservé à l’administrateur 🚫"
    end
  end
end
