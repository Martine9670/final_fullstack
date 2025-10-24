class Review < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy     # ❤️ un avis peut avoir plusieurs likes
  has_many :comments, dependent: :destroy  # 💬 un avis peut avoir plusieurs commentaires

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :rating, presence: true, inclusion: { in: 1..5 }

  # Vérifie si un utilisateur a déjà liké cet avis
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end

