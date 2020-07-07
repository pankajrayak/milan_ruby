require "rails_helper"
require "watir"

feature "signing in" do
    # let(:user) {FactoryGirl.create(:user)}
    email=  User.email("nitish@ziggletech.com")
    password= User.password("A12345z@")

    def fill_insign_in_fields
        fill_in "user[email]", with: email
        fill_in "user[password]", with: password
        click_button "login"
    end

    scenario "visting the site to sign in" do
        visit root_path
        click_link "Login"
        fill_insign_in_fields
        expect(page).to have_content("Create Your Profile")
    end
end