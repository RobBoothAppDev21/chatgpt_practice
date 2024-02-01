require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/sign_up"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    pending it "returns http success" do
      get "/users/create"
      expect(response).to have_http_status(:success)
    end
  end

end
