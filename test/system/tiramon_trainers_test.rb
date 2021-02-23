require "application_system_test_case"

class TiramonTrainersTest < ApplicationSystemTestCase
  setup do
    @tiramon_trainer = tiramon_trainers(:one)
  end

  test "visiting the index" do
    visit tiramon_trainers_url
    assert_selector "h1", text: "Tiramon Trainers"
  end

  test "creating a Tiramon trainer" do
    visit tiramon_trainers_url
    click_on "New Tiramon Trainer"

    fill_in "Experience", with: @tiramon_trainer.experience
    fill_in "Level", with: @tiramon_trainer.level
    fill_in "Tiramon ball", with: @tiramon_trainer.tiramon_ball
    fill_in "User", with: @tiramon_trainer.user_id
    click_on "Create Tiramon trainer"

    assert_text "Tiramon trainer was successfully created"
    click_on "Back"
  end

  test "updating a Tiramon trainer" do
    visit tiramon_trainers_url
    click_on "Edit", match: :first

    fill_in "Experience", with: @tiramon_trainer.experience
    fill_in "Level", with: @tiramon_trainer.level
    fill_in "Tiramon ball", with: @tiramon_trainer.tiramon_ball
    fill_in "User", with: @tiramon_trainer.user_id
    click_on "Update Tiramon trainer"

    assert_text "Tiramon trainer was successfully updated"
    click_on "Back"
  end

  test "destroying a Tiramon trainer" do
    visit tiramon_trainers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tiramon trainer was successfully destroyed"
  end
end
