require "application_system_test_case"

class TextsTest < ApplicationSystemTestCase
  setup do
    @text = texts(:one)
  end

  test "visiting the index" do
    visit texts_url
    assert_selector "h1", text: "Texts"
  end

  test "creating a Text" do
    visit texts_url
    click_on "New Text"

    fill_in "Content", with: @text.content
    fill_in "Create datetime", with: @text.create_datetime
    fill_in "Tweet", with: @text.tweet_id
    fill_in "User", with: @text.user_id
    click_on "Create Text"

    assert_text "Text was successfully created"
    click_on "Back"
  end

  test "updating a Text" do
    visit texts_url
    click_on "Edit", match: :first

    fill_in "Content", with: @text.content
    fill_in "Create datetime", with: @text.create_datetime
    fill_in "Tweet", with: @text.tweet_id
    fill_in "User", with: @text.user_id
    click_on "Update Text"

    assert_text "Text was successfully updated"
    click_on "Back"
  end

  test "destroying a Text" do
    visit texts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Text was successfully destroyed"
  end
end
