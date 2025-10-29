class Review < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy     
  has_many :comments, dependent: :destroy 

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :rating, presence: true, inclusion: { in: 1..5 }

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end

