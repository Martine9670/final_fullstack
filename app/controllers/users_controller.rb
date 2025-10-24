# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!  # seuls les users connectés peuvent accéder

  # GET /user/edit
  def edit
    @user = current_user  # récupère l'utilisateur connecté
  end

  # PATCH/PUT /user
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path, notice: "✅ Profil mis à jour avec succès !"
    else
      flash.now[:alert] = "❌ Erreur : certaines informations sont invalides."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # On autorise uniquement les attributs modifiables par l'utilisateur
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

