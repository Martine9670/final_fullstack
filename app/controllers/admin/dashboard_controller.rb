class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
    @appointments = Appointment.all
  end

  private

  def check_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Accès réservé à l’administrateur 🚫"
    end
  end
end

