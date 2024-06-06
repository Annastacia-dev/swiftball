require "application_system_test_case"

class ToursTest < ApplicationSystemTestCase
  setup do
    @tour = tours(:one)
  end

  test "visiting the index" do
    visit tours_url
    assert_selector "h1", text: "Tours"
  end

  test "should create tour" do
    visit tours_url
    click_on "New tour"

    fill_in "Number", with: @tour.number
    fill_in "Start time", with: @tour.start_time
    fill_in "Timezone", with: @tour.timezone
    fill_in "Title", with: @tour.title
    click_on "Create Tour"

    assert_text "Tour was successfully created"
    click_on "Back"
  end

  test "should update Tour" do
    visit tour_url(@tour)
    click_on "Edit this tour", match: :first

    fill_in "Number", with: @tour.number
    fill_in "Start time", with: @tour.start_time
    fill_in "Timezone", with: @tour.timezone
    fill_in "Title", with: @tour.title
    click_on "Update Tour"

    assert_text "Tour was successfully updated"
    click_on "Back"
  end

  test "should destroy Tour" do
    visit tour_url(@tour)
    click_on "Destroy this tour", match: :first

    assert_text "Tour was successfully destroyed"
  end
end
