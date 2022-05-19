require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :request do

  shared_examples_for "response_unauthorized" do |params|
    it "response Unauthorized" do
      post "/api/v1/sessions", params: params
      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(response_json["title"]).to eq "Unauthorized"
      expect(response_json["detail"]).to eq "Authentication failure"
    end
  end

  describe "auth user" do
    before do
      # signup user
      post "/api/v1/users", params: { email: "example@example.com", password: "example" }
    end

    context "no email" do
      it_behaves_like "response_unauthorized", { password: "example" }
    end
    context "no password" do
      it_behaves_like "response_unauthorized", { email: "example@example.com" }
    end
    context "invalid email" do
      it_behaves_like "response_unauthorized", { email: "examplea@example.com", password: "example" }
    end
    context "invalid password" do
      it_behaves_like "response_unauthorized", { email: "example@example.com", password: "examplea" }
    end
    context "correct parameters" do
      it "response Success" do
        post "/api/v1/sessions", params: { email: "example@example.com", password: "example" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq "Successful authentication"
      end
    end
  end

end
