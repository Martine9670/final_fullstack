class CommentLikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment
  
    def toggle
      like = @comment.comment_likes.find_by(user: current_user)
  
      if like
        like.destroy
      else
        @comment.comment_likes.create(user: current_user)
      end
  
      redirect_to review_path(@comment.review)
    end
  
    private
  
    def set_comment
      @comment = Comment.find(params[:comment_id])
    end
  end
  