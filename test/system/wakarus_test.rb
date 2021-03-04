require "application_system_test_case"

class WakarusTest < ApplicationSystemTestCase
  setup do
    @wakaru = wakarus(:one)
  end

  test "visiting the index" do
    visit wakarus_url
    assert_selector "h1", text: "Wakarus"
  end

  test "creating a Wakaru" do
    visit wakarus_url
    click_on "New Wakaru"

    click_on "Create Wakaru"

    assert_text "Wakaru was successfully created"
    click_on "Back"
  end

  test "updating a Wakaru" do
    visit wakarus_url
    click_on "Edit", match: :first

    click_on "Update Wakaru"

    assert_text "Wakaru was successfully updated"
    click_on "Back"
  end

  test "destroying a Wakaru" do
    visit wakarus_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Wakaru was successfully destroyed"
  end
end
