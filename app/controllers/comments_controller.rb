class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_review
  
    def create
      @comment = @review.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to review_path(@review), notice: "Commentaire ajouté !"
      else
        redirect_to review_path(@review), alert: "Le commentaire ne peut pas être vide."
      end
    end
  
    private
  
    def set_review
      @review = Review.find(params[:review_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  