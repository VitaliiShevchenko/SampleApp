require 'rails_helper'



RSpec.describe NewUser, type: :model do
  context "should be valid all fields"
  new_user = NewUser.new(name: "f", email: "ukraine@ukr.net", password: "fA4'_fA4'fA4'", password_confirmation: "fA4'_fA4'fA4'")
  it "should be valid" do
    expect(new_user.valid?).to be true
  end

  it "should be valid when :name is present" do
    new_user.name = ""
     expect(new_user.valid?).not_to be true
  end
  it "should be valid when :email is present" do
    new_user.email = ""
    expect(new_user.valid?).not_to be true
  end

  it "should be not valid when :name &/or :email too long" do
    new_user.name = "f"*51
    new_user.email = "u"*248+"@ukr.net"
     expect(new_user.valid?).to be false
  end
  it "should be valid with valid email" do
    new_user.name = "vitalii"
    valid_emails = %w[iksel@ukr.net allavital76@outlook.com nika.sviatik.dg5re@gmail.com HgjFKJGd@AmaZoN.com]
    valid_emails.each do |valid_email|
    new_user.email = valid_email
    expect(new_user.valid?).to be true
    end
  end
  it "should be not valid with invalid email" do
    new_user.name = "vitalii"
    invalid_emails = %w[iksel@ukr,net allavital76@outlook. nika.sviat ikdg@egmail..com HgjFKJG"d@Ama. ZoN.com]
    invalid_emails.each do |invalid_email|
      new_user.email = invalid_email
      #puts invalid_email
      expect(new_user.valid?).not_to be true
    end
  end
  it "email should be unique" do
    new_user.name = "vitalii"
    new_user.email = "ikselement4@gamil.com"
    dup = new_user.dup
    dup.email = new_user.email.upcase
    new_user.save
      expect(dup.valid?).not_to be true
  end
  it "password should be more 6 symbols" do
    new_user.password = new_user.password_confirmation = "Fo0_#"
    expect(new_user.valid?).not_to be true
  end
    it "password should have set at least one upcase, downcase, number, special symbols and underscore with length more 6 symbols" do

    puts new_user.password = new_user.password_confirmation = "__ShEv#6"
    expect(new_user.valid?).to be true
  end
end
