class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_review, only: [:show, :destroy]

  def index
    @reviews = Review.includes(:user).order(created_at: :desc)
  end

  def show
    @comments = @review.comments.includes(:user) 
    @comment = Comment.new 
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to reviews_path, notice: "Merci pour votre avis !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_admin!
    @review.destroy
    redirect_to reviews_path, notice: "Avis supprimé."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:title, :content, :rating)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Action non autorisée." unless current_user.admin?
  end
end

  
  