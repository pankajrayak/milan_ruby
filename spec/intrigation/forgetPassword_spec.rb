require "rails_helper"
require "watir"

RSpec.describe User, :type => :model do

    before(:all) do
      @browser = Watir::Browser.new
      @browser.goto '0.0.0.0:3000'
      @browser.link(:text,"Login").click
    end

    context "Forget Password Page" do        
            it "Email field should not be blank" do
                @browser.link(:text ,"Forgot your password?").click
                @browser.button(:value ,"Send me reset password instructions").click   

                expect(@browser.li(xpath: '//*[@id="error_explanation"]/ul/li').text).to eq("Email can't be blank")
            end
        
    
    end

end