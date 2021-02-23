require "application_system_test_case"

class TiramonTrainingsTest < ApplicationSystemTestCase
  setup do
    @tiramon_training = tiramon_trainings(:one)
  end

  test "visiting the index" do
    visit tiramon_trainings_url
    assert_selector "h1", text: "Tiramon Trainings"
  end

  test "creating a Tiramon training" do
    visit tiramon_trainings_url
    click_on "New Tiramon Training"

    fill_in "Level", with: @tiramon_training.level
    fill_in "Training", with: @tiramon_training.training
    click_on "Create Tiramon training"

    assert_text "Tiramon training was successfully created"
    click_on "Back"
  end

  test "updating a Tiramon training" do
    visit tiramon_trainings_url
    click_on "Edit", match: :first

    fill_in "Level", with: @tiramon_training.level
    fill_in "Training", with: @tiramon_training.training
    click_on "Update Tiramon training"

    assert_text "Tiramon training was successfully updated"
    click_on "Back"
  end

  test "destroying a Tiramon training" do
    visit tiramon_trainings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tiramon training was successfully destroyed"
  end
end
