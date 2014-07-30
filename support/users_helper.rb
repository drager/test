module UserHelper

  def login_user(user)
    visit session_path
    within('main') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
  end

  def logout_user
    visit root_path
    click_link 'Logout'
  end

end
