class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }

  def liked_by?(user)
    comment_likes.exists?(user_id: user.id)
  end
end






