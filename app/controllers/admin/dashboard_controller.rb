class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
    @appointments = Appointment.all
  end

  def promote
    user = User.find(params[:id])
    if user.update(admin: true)
      redirect_to admin_dashboard_path, notice: "#{user.email} est maintenant admin 👑"
    else
      redirect_to admin_dashboard_path, alert: "Impossible de promouvoir cet utilisateur."
    end
  end

  private

  def check_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Accès réservé à l’administrateur 🚫"
    end
  end
end
