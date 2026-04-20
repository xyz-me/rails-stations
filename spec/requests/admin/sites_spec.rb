require 'rails_helper'

RSpec.describe "Admin::Sites", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/sites/index"
      expect(response).to have_http_status(:success)
    end
  end

end
