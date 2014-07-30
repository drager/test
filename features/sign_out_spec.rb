require 'spec_helper'
require 'faker'

feature 'Signing out' do
  background do
    @user = create(:user, username: 'ellen.u', email: 'ellen.u@lnu.se', password: 'test123', password_confirmation: 'test123')
  end

  scenario 'signs the user out successfully' do
    login_user(@user)
    logout_user
    user_sees_success_message 'Successfully logged out!'
  end

end
