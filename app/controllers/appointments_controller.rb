class AppointmentsController < ApplicationController
  before_action :authenticate_user!            # l'utilisateur doit être connecté
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # Affiche tous les rendez-vous de l'utilisateur connecté
  def index
    @appointments = current_user.appointments
  end

  def show
    @appointment = current_user.appointments.find(params[:id])
  end

  # Formulaire pour créer un nouveau rendez-vous
  def new
    @appointment = current_user.appointments.build
  end

  # Création d'un rendez-vous
  def create
    @appointment = current_user.appointments.build(appointment_params)
    if @appointment.save
      redirect_to appointments_path, notice: "Rendez-vous créé avec succès !"
    else
      render :new, alert: "Erreur lors de la création du rendez-vous."
    end
  end

  # Formulaire pour éditer un rendez-vous existant
  def edit
    @appointment = current_user.appointments.find(params[:id])
  end

  # Mise à jour d'un rendez-vous
  def update
    @appointment = current_user.appointments.find(params[:id])
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: "Rendez-vous mis à jour avec succès !"
    else
      render :edit, alert: "Erreur lors de la mise à jour du rendez-vous."
    end
  end

  # Suppression d'un rendez-vous
  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Rendez-vous supprimé !"
  end

  private

  # Récupère le rendez-vous courant de l'utilisateur connecté
  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  # Paramètres autorisés pour créer ou mettre à jour un rendez-vous
  def appointment_params
    params.require(:appointment).permit(:date, :time, :notes)
  end
end

