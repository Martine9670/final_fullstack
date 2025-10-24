class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review

  # Un utilisateur ne peut liker qu'une fois un avis
  validates :user_id, uniqueness: { scope: :review_id }
end
