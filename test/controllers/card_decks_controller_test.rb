require 'test_helper'

class CardDecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_deck = card_decks(:one)
  end

  test "should get index" do
    get card_decks_url
    assert_response :success
  end

  test "should get new" do
    get new_card_deck_url
    assert_response :success
  end

  test "should create card_deck" do
    assert_difference('CardDeck.count') do
      post card_decks_url, params: { card_deck: { card_1: @card_deck.card_1, card_2: @card_deck.card_2, card_3: @card_deck.card_3, create_datetime: @card_deck.create_datetime, user_id: @card_deck.user_id } }
    end

    assert_redirected_to card_deck_url(CardDeck.last)
  end

  test "should show card_deck" do
    get card_deck_url(@card_deck)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_deck_url(@card_deck)
    assert_response :success
  end

  test "should update card_deck" do
    patch card_deck_url(@card_deck), params: { card_deck: { card_1: @card_deck.card_1, card_2: @card_deck.card_2, card_3: @card_deck.card_3, create_datetime: @card_deck.create_datetime, user_id: @card_deck.user_id } }
    assert_redirected_to card_deck_url(@card_deck)
  end

  test "should destroy card_deck" do
    assert_difference('CardDeck.count', -1) do
      delete card_deck_url(@card_deck)
    end

    assert_redirected_to card_decks_url
  end
end
