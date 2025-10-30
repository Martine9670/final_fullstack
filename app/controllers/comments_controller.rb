class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @comment = @review.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to review_path(@review), notice: "💬 Commentaire ajouté !"
    else
      redirect_to review_path(@review), alert: "❌ Le commentaire ne peut pas être vide."
    end
  end

  def destroy
    @comment.destroy
    redirect_to review_path(@review), notice: "🗑️ Commentaire supprimé avec succès."
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def set_comment
    @comment = @review.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  # Encapsulation of authorization logic
  def authorize_user!
    unless current_user == @comment.user || current_user.admin?
      redirect_to review_path(@review), alert: "⛔ Action non autorisée."
    end
  end
end
