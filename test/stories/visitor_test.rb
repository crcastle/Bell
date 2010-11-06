# encoding: UTF-8

require File.join(File.dirname(__FILE__), "../test_helper")
require File.join(File.dirname(__FILE__), "../stories_helper")

class VisitorTest < Test::Unit::TestCase
  setup do
    Ohm.flush
  end

  def login(username, password)
    visit "/login"
  
    fill_in "Your username", :with => username
    fill_in "Your password", :with => password

    click_button "Login"
  end
  
  story "As a visitor I want to create an account so that I can access restricted features." do
    scenario "A visitor submits good information" do
      visit "/"
      
      click_link "Sign up"
      
      fill_in "Choose a username", :with => "albert"
      fill_in "And a password", :with => "monkey"
      
      click_button "Sign up"
      
      assert_contain "Logged in as"
      assert_contain "albert"
    end
    
    scenario "A visitor submits an existing username" do
      visit "/"
      
      click_link "Sign up"
      
      fill_in "Choose a username", :with => "albert"
      fill_in "And a password", :with => "monkey"
      
      click_button "Sign up"
      
      assert_contain "Someone else owns the username “albert”."
    end
  end
end      
    