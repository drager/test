require 'spec_helper'
require 'faker'

feature 'Signing in' do
  let(:user) { create(:user) }
  let(:other_user) { build(:user) }

  scenario 'signs the user in successfully with a valid email and password' do
    login_user(user)
    user_sees_success_message 'Successfully logged in as'
  end

  scenario 'notifies the user if his email or password is invalid' do
    login_user(other_user)
    user_sees_error_message 'Invalid email or password...'
  end
end
