require 'test_helper'

class TiramonTrainingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiramon_training = tiramon_trainings(:one)
  end

  test "should get index" do
    get tiramon_trainings_url
    assert_response :success
  end

  test "should get new" do
    get new_tiramon_training_url
    assert_response :success
  end

  test "should create tiramon_training" do
    assert_difference('TiramonTraining.count') do
      post tiramon_trainings_url, params: { tiramon_training: { level: @tiramon_training.level, training: @tiramon_training.training } }
    end

    assert_redirected_to tiramon_training_url(TiramonTraining.last)
  end

  test "should show tiramon_training" do
    get tiramon_training_url(@tiramon_training)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiramon_training_url(@tiramon_training)
    assert_response :success
  end

  test "should update tiramon_training" do
    patch tiramon_training_url(@tiramon_training), params: { tiramon_training: { level: @tiramon_training.level, training: @tiramon_training.training } }
    assert_redirected_to tiramon_training_url(@tiramon_training)
  end

  test "should destroy tiramon_training" do
    assert_difference('TiramonTraining.count', -1) do
      delete tiramon_training_url(@tiramon_training)
    end

    assert_redirected_to tiramon_trainings_url
  end
end
