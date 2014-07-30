require 'spec_helper'
require 'faker'

=begin
feature 'Reset password' do
  let(:user) { create(:user) }

  context 'when email exists' do
    scenario 'successfully sends an email with instructions' do
      visit root_path

      reset_password user.email

      user_sees_success_message 'Email instructions for resetting your password has been sent to the email specified.'
    end
  end

  context 'when email does not exist' do
    scenario 'does not send an email and show error message' do
      visit root_path

      reset_password Faker::Internet.email

      user_sees_error_message "Email not found, are you sure it's the right email?"
    end
  end

  def reset_password(email)
    click_link 'Forgot password?'

    fill_in 'Email', with: user.email

    click_button 'Reset password'
  end
end
=end
