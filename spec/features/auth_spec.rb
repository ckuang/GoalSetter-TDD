require 'rails_helper'


feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content("New User")
  end



  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in "username", with: "thechuckmeista"
      fill_in "password", with: "starwars"
      click_on "Sign Up"
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content("Home")
      expect(page).to have_content("thechuckmeista")
    end

  end

end

feature "logging in" do

  let!(:charles) {build(:user)}

  before(:each) do
    charles.save!
    visit new_session_url
    fill_in "username", with: charles.username
    fill_in "password", with: charles.password
    click_on "Sign In"
  end

  scenario "shows username on the homepage after login" do
    save_and_open_page
    expect(page).to have_content("Home")
    expect(page).to have_content("thechuckmeista")
  end

end

feature "logging out" do

  scenario "begins with logged out state" do
    visit new_session_url
    expect(page).to have_content("Create a new account")
    expect(page).to have_content("Login")
  end

  let!(:charles) {build(:user)}

  scenario "doesn't show username on the homepage after logout" do
    charles.save!
    visit new_session_url
    fill_in "username", with: charles.username
    fill_in "password", with: charles.password
    click_on "Sign In"
    click_on "Sign Out"

    expect(page).not_to have_content("thechuckmeista")
  end

end
