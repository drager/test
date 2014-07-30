require 'spec_helper'
require 'faker'

feature 'Create user' do
  scenario 'creates a user successfully with a valid username, email and password' do
    register_with Faker::Internet.user_name, 'test123', 'test123', Faker::Internet.email
    user_sees_success_message "Registered successfully!"
  end

  scenario 'notifies the user if his username is invalid' do
    register_with nil, 'test123', 'test123', Faker::Internet.email
    user_sees_error_message "Username can't be blank"
  end

  scenario 'notifies the user if his username is to short' do
    register_with 'el', 'test123', 'test123', Faker::Internet.email
    user_sees_error_message "Username is too short (minimum is 3 characters)"
  end

  scenario 'notifies the user if his email is invalid' do
    register_with Faker::Internet.user_name, 'test123', 'test123', nil
    user_sees_error_message "Email can't be blank"
  end

  scenario 'notifies the user if his password is to short' do
    register_with Faker::Internet.user_name, 'test', 'test', Faker::Internet.email
    user_sees_error_message "Password is too short (minimum is 6 characters)"
  end

  scenario 'notifies the user if his password doesnt match' do
    register_with Faker::Internet.user_name, 'test123', 'test321', Faker::Internet.email
    user_sees_error_message "Password confirmation doesn't match Password"
  end

  def register_with(username, password, password_confirm, email)
    visit new_user_path
    within('main') do
      fill_in 'Username', with: username
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password_confirm
      fill_in 'Email', with: email
      click_button 'Register'
    end
  end
end
