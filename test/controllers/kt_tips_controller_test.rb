require 'test_helper'

class KtTipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kt_tip = kt_tips(:one)
  end

  test "should get index" do
    get kt_tips_url
    assert_response :success
  end

  test "should get new" do
    get new_kt_tip_url
    assert_response :success
  end

  test "should create kt_tip" do
    assert_difference('KtTip.count') do
      post kt_tips_url, params: { kt_tip: { content: @kt_tip.content, likes: @kt_tip.likes, topic: @kt_tip.topic, written_on: @kt_tip.written_on } }
    end

    assert_redirected_to kt_tip_url(KtTip.last)
  end

  test "should show kt_tip" do
    get kt_tip_url(@kt_tip)
    assert_response :success
  end

  test "should get edit" do
    get edit_kt_tip_url(@kt_tip)
    assert_response :success
  end

  test "should update kt_tip" do
    patch kt_tip_url(@kt_tip), params: { kt_tip: { content: @kt_tip.content, likes: @kt_tip.likes, topic: @kt_tip.topic, written_on: @kt_tip.written_on } }
    assert_redirected_to kt_tip_url(@kt_tip)
  end

  test "should destroy kt_tip" do
    assert_difference('KtTip.count', -1) do
      delete kt_tip_url(@kt_tip)
    end

    assert_redirected_to kt_tips_url
  end
end
