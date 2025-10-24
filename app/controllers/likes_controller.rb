class LikesController < ApplicationController
    before_action :authenticate_user!
  
    def toggle
      @review = Review.find(params[:review_id])
      like = @review.likes.find_by(user: current_user)
  
      if like
        like.destroy
      else
        @review.likes.create(user: current_user)
      end
  
      redirect_to review_path(@review)
    end
  end
  
  