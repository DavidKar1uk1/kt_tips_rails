require "application_system_test_case"

class KtTipsTest < ApplicationSystemTestCase
  setup do
    @kt_tip = kt_tips(:one)
  end

  test "visiting the index" do
    visit kt_tips_url
    assert_selector "h1", text: "Kt Tips"
  end

  test "creating a Kt tip" do
    visit kt_tips_url
    click_on "New Kt Tip"

    fill_in "Content", with: @kt_tip.content
    fill_in "Likes", with: @kt_tip.likes
    fill_in "Topic", with: @kt_tip.topic
    fill_in "Written on", with: @kt_tip.written_on
    click_on "Create Kt tip"

    assert_text "Kt tip was successfully created"
    click_on "Back"
  end

  test "updating a Kt tip" do
    visit kt_tips_url
    click_on "Edit", match: :first

    fill_in "Content", with: @kt_tip.content
    fill_in "Likes", with: @kt_tip.likes
    fill_in "Topic", with: @kt_tip.topic
    fill_in "Written on", with: @kt_tip.written_on
    click_on "Update Kt tip"

    assert_text "Kt tip was successfully updated"
    click_on "Back"
  end

  test "destroying a Kt tip" do
    visit kt_tips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Kt tip was successfully destroyed"
  end
end
