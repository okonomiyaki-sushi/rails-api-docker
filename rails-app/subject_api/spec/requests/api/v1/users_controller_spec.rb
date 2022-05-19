require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :request do

  describe "signup user" do
    context "not found" do
      it "response Not Found" do
        post "/api/v1/usersa", params: { email: "example_user@example.com", password: "example" }
        expect(response).to have_http_status(:not_found)
      end
    end
    context "no email" do
      it "response Bad Request" do
        post "/api/v1/users", params: { password: "example" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(User.find_by(email: "example_user@example.com").present?).to be_falsey
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Email can't be blank", "Email is invalid"]
      end
    end
    context "invalid email" do
      it "response Bad Request" do
        post "/api/v1/users", params: { email: "example_userexample.com", password: "example" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Email is invalid"]
      end
    end
    context "email is too long" do
      it "response Bad Request" do
        post "/api/v1/users", params: { email: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234@example.com", password: "example" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Email is too long (maximum is 255 characters)"]
      end
    end
    context "no password" do
      it "response Bad Request" do
        post "/api/v1/users", params: { email: "example_user@example.com" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(User.find_by(email: "example_user@example.com").present?).to be_falsey
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Password can't be blank"]
      end
    end
    context "password is too long" do
      it "response Bad Request" do
        post "/api/v1/users", params: { email: "example_user@example.com", password: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(User.find_by(email: "example_user@example.com").present?).to be_falsey
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Password is too long (maximum is 72 characters)"]
      end
    end
    context "correct parameters" do
      it "response Created" do
        post "/api/v1/users", params: { email: "example_user@example.com", password: "example" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(User.find_by(email: "example_user@example.com").present?).to be_truthy
        expect(User.find_by(email: "example_user@example.com").ownerd_points).to be 10000
        expect(response_json["title"]).to eq "Created"
        expect(response_json["detail"]).to eq "Created a user"
      end
    end
  end

end
