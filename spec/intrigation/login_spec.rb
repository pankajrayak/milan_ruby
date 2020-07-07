require "rails_helper"
require "watir"


RSpec.describe User, :type => :model do

  before(:all) do
    @browser = Watir::Browser.new
    @browser.goto 'http://54.215.241.71'
    @browser.goto('http://54.215.241.71/users/sign_in')
  end

 

 context "Login page" do

        it "username filed should be presence" do
        #   @browser.text_field(:id ,"user_email").set("xyz@sd.com")
          @browser.text_field(:id ,"user_password").set("Atul1@ziggletech.com")
          @browser.button(:value ,"Log in").click   
          @browser.text.should include("Invalid Email or password.")
        end

        it "Password filed should be presence" do
            @browser.text_field(:id ,"user_email").set("atul@ziggletech.com")
            #   @browser.text_field(:id ,"user_password").set("A12345z@")
            @browser.button(:value ,"Log in").click   
            @browser.text.should include("Invalid Email or password.")
        end

        it "UnAuthorized user should not be login" do
            @browser.text_field(:id ,"user_email").set("nitish@ziggletech.com")
            @browser.text_field(:id ,"user_password").set("A12345z@")
            @browser.button(:value ,"Log in").click   
            # @browser.text.should include("You have to confirm your email address before continuing.")
            expect(@browser.element(:id ,'flash_alert').text).to eq("Invalid Email or password.")
            # @browser.button(:value ,"Log out").click
        end

        # it "Authorized user should be login with right credential" do
        #     @browser.text_field(:id ,"user_email").set("xwz@ziggletech.com")
        #     @browser.text_field(:id ,"user_password").set("A12345z@")
        #     @browser.button(:value ,"Log in").click   
        #     sleep(3)
        #     @browser.text.should include("Create Your Profile")
        # end

        it "Authorized user should be login" do
            @browser.text_field(:id ,"user_email").set("atul@ziggletech.com")
            @browser.text_field(:id ,"user_password").set("Atul1@ziggletech.com")
            @browser.button(:value ,"Log in").click   
            # @browser.text.should include("You have to confirm your email address before continuing.")
            expect(@browser.element(:id ,'flash_notice').text).to eq("Signed in successfully.")
            # @browser.link(:text ,"Log out").click
        end
       
        it "User  should be able to sign out clicking on sign out page." do

            @browser.link(:text ,"Log out").click 
            @browser.text.should include("You need to sign in or sign up before continuing.")
        end

        it "Sign up page  link in login page" do
            # visit 'users/sign_in' 
            @browser.goto('http://54.215.241.71/users/sign_in')            
            @browser.link(:text ,"Sign up").click   
            expect(@browser.url).to eq("http://54.215.241.71/users/sign_up")            
        end

        it "Forget Password link on login page" do
            # visit 'users/sign_in'
            @browser.goto('http://54.215.241.71/users/sign_in') 
            @browser.link(:text ,"Forgot your password?").click   
            @browser.text.should include("Forgot your password?")
            expect(@browser.url).to eq("http://54.215.241.71/users/password/new")
        end

       
 end


 context "Admin and customer user" do
    
    it "Admin user should be login as admin user" do
        # @browser.link(:text,"Login").click 
        @browser.goto 'http://54.215.241.71/users/sign_in'       
        @browser.text_field(:id ,"user_email").set("atul@ziggletech.com")
        @browser.text_field(:id ,"user_password").set("Atul1@ziggletech.com")
        @browser.button(:value ,"Log in").click 
        expect(@browser.a(xpath: '/html/body/nav/div/div[2]/ul/li[3]/a').text).to eq("Admin")      
    end                           
    
    it "logout" do
        @browser.link(:text,"Log out").click
    end
    # @browser.link(:text,"Logout").click
    # @browser.link(:text,"Login").click    # .wait_until_present  

    it "cutomer user should not be login as admin user" do
        @browser.goto 'http://54.215.241.71/users/sign_in'   # .wait_until_present          
        @browser.text_field(:id ,"user_email").set("ankit@ziggletech.com")
        @browser.text_field(:id ,"user_password").set("Ankit1@ziggletech.com")
        @browser.button(:value ,"Log in").click  
        sleep(3)
        @browser.text.include?('Admin').should==false
    end

    it "logout" do
        @browser.link(:text,"Log out").click
    end

 end

 context "Admin Dashboard testing" do
  
    context "Admin Navbar Link shoud be work" do

        it "login" do
            @browser.goto 'http://54.215.241.71/users/sign_in'   # .wait_until_present          
            @browser.text_field(:id ,"user_email").set("atul@ziggletech.com")
            @browser.text_field(:id ,"user_password").set("Atul1@ziggletech.com")
            @browser.button(:value ,"Log in").click 
        end
        
        it "Users Requests link should be go to request page" do
            # @browser.link(:text,'Pending Requests').click
            @browser.link(xpath: '/html/body/nav/div/div[2]/ul/li[3]/a').click  #click on admin
            @browser.link(xpath: '/html/body/nav/div/div[2]/ul/li[3]/ul/li[1]/a').click         
            expect(@browser.element(xpath: '/html/body/div[1]/div[2]/h2').text).to eq 'User List'
        end

        it "Additional Requests link shoud be open Additional Requests Tab" do
            @browser.link(text: 'Admin').click    #click on admin  
            @browser.link(xpath: '/html/body/nav/div/div[2]/ul/li[3]/ul/li[2]/a').click
            expect(@browser.element(xpath: '/html/body/div[1]/div[2]/h2').text).to eq 'Additional Requests'                   
        end

        it "logout" do
            @browser.link(:text ,"Log out").click 
        end

    end

    context "Regional manager" do
        it "login" do
            @browser.goto 'http://54.215.241.71/users/sign_in'   
            sleep(3)          
            @browser.text_field(:id ,"user_email").set("ankit@ziggletech.com")
            @browser.text_field(:id ,"user_password").set("Ankit1@ziggletech.com")
            @browser.button(:value ,"Log in").click 
            sleep(3)
            @browser.link(xpath: '/html/body/div[2]/a').click
        end 
        
        it "Email should be presence" do
            # @browser.text_field(:id,'user_email').set("paras@ziggletect.com")
            @browser.text_field(:id,'user_password').set("A12345z@")
            @browser.text_field(:id,'user_password_confirmation').set("A12345z@")
            @browser.text_field(:id,'user_first_name').set("paras")
            @browser.text_field(:id,'user_last_name').set("koti")
            @browser.text_field(:id,'user_dob').set("12/12/1998")
            region = @browser.text_field(:id,'user_region')
            allow(region).to receive(:name) {'New jersey'}
            @browser.button(xpath: '//*[@id="new_user"]/div[8]/input').click
            sleep(3)
            
        end
    
    end


 end


end