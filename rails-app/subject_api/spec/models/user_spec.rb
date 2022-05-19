require "rails_helper"

RSpec.describe User, type: :model do
  
  describe "#User create" do
    context "invalid email" do
      it "validation error" do
        user = build(:user, email: "exampleexample.com")
        user.valid?
        expect(user.errors.full_messages).to eq ["Email is invalid"]
      end
    end
    context "email is too long" do
      it "validation error" do
        user = build(:user, email: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234@example.com")
        user.valid?
        expect(user.errors.full_messages).to eq ["Email is too long (maximum is 255 characters)"]
      end
    end
    context "no password" do
      it "validation error" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors.full_messages).to eq ["Password can't be blank"]
      end
    end
    context "password is too long" do
      it "validation error" do
        user = build(:user, password: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456")
        user.valid?
        expect(user.errors.full_messages).to eq ["Password is too long (maximum is 72 characters)"]
      end
    end
    context "correct parameters" do
      it "validation success" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
  end
end