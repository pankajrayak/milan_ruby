require "rails_helper"
require "watir"


RSpec.describe User, :type => :model do

  before(:all) do
    @browser = Watir::Browser.new
    @browser.goto 'http://54.215.241.71/users/sign_up'
  end
  context "Validation user" do

    it "user can register without first name" do
         @browser.goto 'http://54.215.241.71/users/sign_up'
        sleep(4)
        @browser.text_field(:id ,"user_email").set("xyz@sd.com")
        @browser.text_field(:id ,"user_password").set("A12345z@")
        @browser.text_field(:id ,"user_password_confirmation").set("A12345z@")
        # @browser.text_field(:id ,"user_first_name").set("first")
         
        @browser.text_field(:id ,"user_last_name").set("last")
        @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
        @browser.button(:value ,"Sign up").click   
        sleep(6)
        @browser.text.should include("First Name is Required.")  
        # sleep(330)
        # @browser.close
    end
    it "user can register without last name" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("A12345z@")
      @browser.text_field(:id ,"user_password_confirmation").set("A12345z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      # @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Last Name is Required.")  
      # sleep(330)
      # @browser.close
    end
    it "user can register without email name" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      # @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("A12345z@")
      @browser.text_field(:id ,"user_password_confirmation").set("A12345z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Enter Correct Email Address.")  
      # sleep(330)
      # @browser.close
    end
    
    it "user can register without Password" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      # @browser.text_field(:id ,"user_password").set("A12345z@")
      @browser.text_field(:id ,"user_password_confirmation").set("A12345z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Password should be greater than 8 letters.")  
      # sleep(330)
      # @browser.close
    end

    it "user can register without Password_confirmation" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("A12345z@")
      # @browser.text_field(:id ,"user_password_confirmation").set("A12345z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Password should be greater than 8 letters.")  
      # sleep(330)
      # @browser.close
    end

    it "Password and Password_confirmation should be same" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("A12345z@")
      @browser.text_field(:id ,"user_password_confirmation").set("A123423c")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include(("Password Does not Match.") && ("Confirm password not valid")&& ("Password confirmation doesn't match Password"))
      # sleep(330)
      # @browser.close
    end

    it "Password must have contain upper case letter " do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("a12345z@")
      @browser.text_field(:id ,"user_password_confirmation").set("a12345z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Password should contain at least one number, one lowercase and one uppercase character.")  
      # sleep(330)
      # @browser.close
    end

    it "Password must have contain lower case letter" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("A12345Z@")
      @browser.text_field(:id ,"user_password_confirmation").set("A12345Z@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Password should contain at least one number, one lowercase and one uppercase character.")  
      # sleep(330)
      # @browser.close
    end

    it "Password must have contain numeric value" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xyz@sd.com")
      @browser.text_field(:id ,"user_password").set("Asfdfdd@")
      @browser.text_field(:id ,"user_password_confirmation").set("Asfdfdd@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(6)
      @browser.text.should include("Password should contain at least one number, one lowercase and one uppercase character.")  
      # sleep(330)
      # @browser.close
    end

    # it "Middel Name should ne optional" do
    #    @browser.goto 'http://54.215.241.71/users/sign_up'
    #   sleep(4)
    #   @browser.text_field(:id ,"user_email").set("xz@sd.com")
    #   @browser.text_field(:id ,"user_password").set("As123dd@")
    #   @browser.text_field(:id ,"user_password_confirmation").set("As123dd@")
    #   @browser.text_field(:id ,"user_first_name").set("first")
    #   #  
    #   @browser.text_field(:id ,"user_last_name").set("last")
    #   @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
    #   @browser.button(:value ,"Sign up").click  
    #   sleep(8) 
    #   @browser.text.should include("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")  
    #   # sleep(330)
    #   # @browser.close
    # end

    it "DOB should be presence" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xxyz@sd.com")
      @browser.text_field(:id ,"user_password").set("Asfd112d@")
      @browser.text_field(:id ,"user_password_confirmation").set("Asfd112d@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      # @browser.input(:id ,"profile_dob").send_keys("05/14/1999")
      @browser.button(:value ,"Sign up").click   
      sleep(8)
      @browser.text.should include("DOB is Required.")  
      # sleep(330)
      # @browser.close
    end
  
    it "DOB should be 18+" do
       @browser.goto 'http://54.215.241.71/users/sign_up'
      sleep(4)
      @browser.text_field(:id ,"user_email").set("xxz@sd.com")
      @browser.text_field(:id ,"user_password").set("Asfd112d@")
      @browser.text_field(:id ,"user_password_confirmation").set("Asfd112d@")
      @browser.text_field(:id ,"user_first_name").set("first")
       
      @browser.text_field(:id ,"user_last_name").set("last")
      @browser.input(:id ,"profile_dob").send_keys("05/14/2002")
      @browser.button(:value ,"Sign up").click   
      sleep(8)
      @browser.text.should include("DOB must be greater than 18 years.")  
      # sleep(330)
      # @browser.close
    end





  end 
  
  after(:all) do
    @browser.close
  end
end