class Appointment < ApplicationRecord
  belongs_to :user

  # ici tu peux ajouter des validations si tu veux
  validates :date, presence: true
  validates :time, presence: true
end
