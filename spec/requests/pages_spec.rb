require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /cgu" do
    it "returns http success" do
      get "/pages/cgu"
      expect(response).to have_http_status(:success)
    end
  end

end
