class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 🌱 Relations
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy  # 👈 ajout de l'association avec les avis

  # 🌟 Méthode utilitaire pour vérifier le statut admin
  def admin?
    self.admin == true
  end
end
