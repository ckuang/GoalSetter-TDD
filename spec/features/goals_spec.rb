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

feature "goals#index" do

  context "logged in" do

    let!(:charles) {build(:user)}

    let!(:swole) { build(:goal) }

    before(:each) do
      charles.save!
      visit new_session_url
      fill_in "username", with: charles.username
      fill_in "password", with: charles.password
      click_on "Sign In"
    end

    before(:each) do
      visit new_goal_url
      fill_in "title", with: swole.title
      fill_in "description", with: swole.description
      choose "public"
      click_on "Create New Goal"
    end

    scenario "user can see all public goals" do
      visit goals_url
      expect(page).to have_content("Getting Swollen")
    end

    scenario "user can see their own private goals" do
      goal = Goal.find_by(1)
      goal.title = "Beedrill"
      goal.description = "Weedle"
      goal.visibility = false
      goal.save
      visit goals_url
      expect(page).to have_content("Beedrill")
    end

    scenario "user cannot see other users' private goals" do
      goal = Goal.find_by(2)
      goal.title = "Butterfree"
      goal.visibility = false
      goal.user_id = 2
      goal.save
      visit goals_url
      save_and_open_page
      expect(page).not_to have_content("Butterfree")
    end

    scenario "clicking on link for goal leads to show page" do
      visit goals_url
      click_on "Getting Swollen"
      expect(page).to have_content("No Bee Stings Though or Anaphylactic Shock")
    end

    scenario "new link button leads to page for new link" do
      visit goals_url
      click_on "New Goal"
      expect(page).to have_button("Create New Goal")
    end

  end

  context "logged out" do

    scenario "can't see goals page" do
      visit goals_url
      expect(page).to have_content("Sign In")
    end

  end

end

feature "goals#show" do

  let!(:charles) {build(:user)}

  let!(:swole) { build(:goal) }

  before(:each) do
    charles.save!
    visit new_session_url
    fill_in "username", with: charles.username
    fill_in "password", with: charles.password
    click_on "Sign In"
  end

  before(:each) do
    visit new_goal_url
    fill_in "title", with: swole.title
    fill_in "description", with: swole.description
    choose "public"
    click_on "Create New Goal"
  end

  scenario "displays goal title" do
    expect(page).to have_content("Getting Swollen")
  end

  scenario "displays goal description" do
    expect(page).to have_content("Anaphylactic")
  end

  scenario "displays ambitioner" do
    save_and_open_page
    expect(page).to have_content("thechuckmeista")
  end

end

feature "goals#destroy" do

  let!(:charles) {build(:user)}

  let!(:swole) { build(:goal) }

  before(:each) do
    charles.save!
    visit new_session_url
    fill_in "username", with: charles.username
    fill_in "password", with: charles.password
    click_on "Sign In"
  end

  before(:each) do
    visit new_goal_url
    fill_in "title", with: swole.title
    fill_in "description", with: swole.description
    choose "public"
    click_on "Create New Goal"
  end

  scenario "user can delete their goal" do
    visit goals_url
    expect(page).to have_button("Delete")
  end

  scenario "user can't delete others' goal" do
    goal = Goal.find(1)
    goal.user_id = 2
    goal.save
    visit goals_url
    expect(page).not_to have_button("Delete")
  end

  scenario "clicking delete removes goal from index" do
    visit goals_url
    click_on "Delete"
    expect(page).not_to have_content("Getting Swollen")
  end

end
