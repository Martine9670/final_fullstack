# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!  # pour que seuls les users connectés accèdent

  def edit
    @user = current_user  # on récupère l'utilisateur connecté
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path, notice: "Profil mis à jour avec succès !"
    else
      render :edit
    end
  end

  private

  def user_params
    # on autorise juste les infos que l'utilisateur peut modifier
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
