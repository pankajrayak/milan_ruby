require "rails_helper"
require "watir"


RSpec.describe User, :type => :model do

  context "Validation user" do
    it "first name sould be presence" do
      user = User.new(lastname: 'last',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "first name sould not be less than 3" do
      user = User.new(firstname: 'aa',lastname: 'last',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "first name sould not be greater than 15" do
      user = User.new(firstname:'aaaaaaaaaaaaaaaa', lastname: 'last',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "last name sould be presence" do
        user = User.new(firstname: 'first',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
        expect(user).to eq(false)
    end

    it "last name sould not be less than 3" do
      user = User.new(firstname: 'aaaaaa',lastname: 'la',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "last name sould not be greater than 15" do
      user = User.new(firstname:'aaaaaaa', lastname: 'aaaalastaaaaaaaa',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "Password sould be presence" do
      user = User.new(firstname:'first',lastname: 'last',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "Password should be greater than 8" do
        user = User.new(firstname: 'first',lastname: 'last' ,password: 'A1235z$',password_confirmation:'A1235z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
        expect(user).to eq(false)
    end

    it "Confirm_password sould be presence" do
      user = User.new(firstname:'first',lastname: 'last',password: 'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "Password and confirm_password must be same" do
      user = User.new(firstname: 'first',lastname: 'last' ,password: 'A12346z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "Password must contain special character" do
      user = User.new(firstname: 'first',lastname: 'last' ,password: 'A12345z3',password_confirmation:'A12345z3',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "email should be presence" do
      user = User.new(firstname: 'first',lastname: 'last' ,password: 'A12346z$',password_confirmation:'A12346z$',middlename: 'jiny',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

    it "email should be valid" do
      user = User.new(firstname: 'first',lastname: 'last',password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmailcom',dob:'02/01/1999').save
      expect(user).to eq(false)
    end

     it "Middle name should be optional" do
      user = User.new(firstname: 'first',lastname: 'last' ,password: 'A12345z$',password_confirmation:'A12345z$',email: 'xyz@gmail.com',dob:'02/01/1999').save
      expect(user).to eq(true)
    end

    it "Age should be 18+" do
      user = User.new(firstname: 'first',lastname: 'last' ,password: 'A12345z$',password_confirmation:'A12345z$',middlename: 'jiny',email: 'xyz@gmail.com',dob:'02/01/2003').save
      expect(user).to eq(false)
    end

    

  end

  context "Validation scope" do
  end

  
end