class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def dashboard
    @users = User.all
    @appointments = Appointment.includes(:user).all
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Accès réservé aux administrateurs."
    end
  end
end
