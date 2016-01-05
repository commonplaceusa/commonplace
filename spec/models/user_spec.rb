require 'spec_helper'

describe User do
  describe "#valid?" do
    it "requires certain fields" do
      user = User.new

      user.valid?

      expect(user.errors.keys).to include :address
      expect(user.errors.keys).to include :community
      expect(user.errors.keys).to include :email
      expect(user.errors.keys).to include :first_name
      expect(user.errors.keys).to include :last_name
      expect(user.errors.keys).to include :full_name
    end
  end

  describe "#full_name" do
    it "is composed of first and last names" do
      user = User.new(
        first_name: "Bob",
        last_name: "Joe",
      )

      expect(user.full_name).to eq "Bob Joe"
    end

    it "is composed of first, middle and last names" do
      user = User.new(
        first_name: "Bob",
        middle_name: "Robert",
        last_name: "Joe",
      )

      expect(user.full_name).to eq "Bob Robert Joe"
    end

    it "capitalizes the first name and last name" do
      user = User.new
      user.full_name = "billy joel"

      expect(user.first_name).to eq "Billy"
      expect(user.last_name).to eq "Joel"
    end

    it "capitalizes first, middle and last names" do
      user = User.new
      user.full_name = "jason ross berlinsky"

      expect(user.first_name).to eq "Jason"
      expect(user.middle_name).to eq "Ross"
      expect(user.last_name).to eq "Berlinsky"
    end

    it "successfully handles changing away from a middle-named name" do
      user = User.new(
        first_name: "Max",
        middle_name: "Forrest",
        last_name: "Tilford",
      )

      user.full_name = "Billy Joel"

      expect(user.first_name).to eq "Billy"
      expect(user.middle_name).to be_empty
      expect(user.last_name).to eq "Joel"
      expect(user.full_name).to eq "Billy Joel"
    end

    it "comprehensively handles a complex middle name" do
      user = User.new
      user.full_name = "jason r w berlinsky"

      expect(user.first_name).to eq "Jason"
      expect(user.last_name).to eq "Berlinsky"
      expect(user.middle_name).to eq "R W"
    end

    it "handles =(nil) gracefully" do
      user = User.new
      user.full_name = nil

      expect(user.first_name).to eq ""
      expect(user.last_name).to eq ""
    end

    it "handles =('') gracefully" do
      user = User.new
      user.full_name = ""

      expect(user.first_name).to eq ""
      expect(user.last_name).to eq ""
    end
  end

  describe "#send_reset_password_instructions" do
    it "regenerates reset_password_token" do
      user = User.new
      allow(user).to receive(:generate_reset_password_token!)
      allow_any_instance_of(KickOff).to receive(:deliver_password_reset)

      user.send_reset_password_instructions

      expect(user).to have_received(:generate_reset_password_token!).exactly(1).times
    end
  end

end
