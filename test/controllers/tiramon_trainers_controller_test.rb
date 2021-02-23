require 'test_helper'

class TiramonTrainersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiramon_trainer = tiramon_trainers(:one)
  end

  test "should get index" do
    get tiramon_trainers_url
    assert_response :success
  end

  test "should get new" do
    get new_tiramon_trainer_url
    assert_response :success
  end

  test "should create tiramon_trainer" do
    assert_difference('TiramonTrainer.count') do
      post tiramon_trainers_url, params: { tiramon_trainer: { experience: @tiramon_trainer.experience, level: @tiramon_trainer.level, tiramon_ball: @tiramon_trainer.tiramon_ball, user_id: @tiramon_trainer.user_id } }
    end

    assert_redirected_to tiramon_trainer_url(TiramonTrainer.last)
  end

  test "should show tiramon_trainer" do
    get tiramon_trainer_url(@tiramon_trainer)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiramon_trainer_url(@tiramon_trainer)
    assert_response :success
  end

  test "should update tiramon_trainer" do
    patch tiramon_trainer_url(@tiramon_trainer), params: { tiramon_trainer: { experience: @tiramon_trainer.experience, level: @tiramon_trainer.level, tiramon_ball: @tiramon_trainer.tiramon_ball, user_id: @tiramon_trainer.user_id } }
    assert_redirected_to tiramon_trainer_url(@tiramon_trainer)
  end

  test "should destroy tiramon_trainer" do
    assert_difference('TiramonTrainer.count', -1) do
      delete tiramon_trainer_url(@tiramon_trainer)
    end

    assert_redirected_to tiramon_trainers_url
  end
end
