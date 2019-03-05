# class Test::StaticPagesTestController < ApplicationController

# end
# require 'test_helper'

class StaticPagesTestController < ActionDispatch::IntegrationTest
	require 'test_helper'

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About"
  end
end