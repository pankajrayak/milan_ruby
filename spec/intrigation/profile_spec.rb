require "rails_helper"
require "watir"


RSpec.describe User, :type => :model do

  before(:all) do
    @browser = Watir::Browser.new
    @browser.goto '0.0.0.0:3000'
    @browser.link(:text,"Login").click
    @browser.text_field(:id ,"user_email").set("nitish@ziggletech.com")
    @browser.text_field(:id ,"user_password").set("A12345z@")
    @browser.button(:value ,"Log in").click  
  end

  context "user Profile page" do
    
    it "Region should be selected" do
       expect(@browser.select_list(:id, "user_region").select_value("")).to eq("")
    end

    it "Radio button for Gender should be toggle" do
        @browser.radio(id: 'user_info_gender_male').set
        expect(@browser.radio(id: 'user_info_gender_female').set?).to eq false
    end

    it "Radio button for Gender should be toggle 2" do
        @browser.radio(id: 'user_info_gender_female').set
        expect(@browser.radio(id: 'user_info_gender_male').set?).to eq false
    end

    it "About us text should contain up to 500 charecter" do
        one_five = 'a'*500
        @browser.textarea(id: 'user_info_about_me').set(one_five)
        expect(@browser.textarea(id: 'user_info_about_me').value == one_five).to eq true
        @browser.textarea(id: 'user_info_about_me').set()        
    end

    it "About us text should not contain more than 500 charecter" do
      five_one = 'a'*501
      @browser.textarea(id: 'user_info_about_me').set(five_one)
      expect(@browser.textarea(id: 'user_info_about_me').value == five_one).to eq false
    end

  end

end