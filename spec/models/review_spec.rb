require 'rails_helper'

RSpec.describe Review, type: :model do
  it "is invalid without a title" do
    review = Review.new(title: nil, content: "Super service !", rating: 5)
    expect(review).to_not be_valid
  end

  it "is valid with all attributes" do
    review = Review.new(title: "Parfait", content: "Super service !", rating: 5, user_id: 1)
    expect(review).to be_valid
  end
end
