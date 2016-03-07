require 'rails_helper'

feature "goals#new" do

  scenario "has form for a new goal" do
    visit new_goal_url
    expect(page).to have_content("new goal")
    expect(page).to have_button("Create New Goal")
  end

end

feature "goals#create" do

  let!(:charles) {build(:user)}

  before(:each) do
    charles.save!
    visit new_session_url
    fill_in "username", with: charles.username
    fill_in "password", with: charles.password
    click_on "Sign In"
  end

  context "on success" do

    let!(:swole) { build(:goal) }

    before(:each) do
      visit new_goal_url
      fill_in "title", with: swole.title
      fill_in "description", with: swole.description
      choose "public"
      click_on "Create New Goal"
    end

    scenario "redirects to page for created goal" do
      expect(page).to have_content("Getting Swollen")
    end

    scenario "adds goal to the index page" do
      visit goals_url
      expect(page).to have_content("Getting Swollen")
    end

  end

  scenario "validates title" do
    visit new_goal_url
    click_on "Create New Goal"
    expect(page).to have_content("Title can't be blank")
  end


  scenario "on failure, redirects to new goal page with error" do
    visit new_goal_url
    click_on "Create New Goal"
    expect(page).to have_button("Create New Goal")
  end

end
