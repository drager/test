require 'spec_helper'
require 'faker'

feature 'Update user' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:staff_user) { create(:user, is_staff: true) }

  scenario 'cannot edit a settings if not owner' do
    login_user(other_user)
    visit edit_user_path(user)
    current_path.should == user_path(user)
  end

  scenario 'can edit any users settings if user is staff' do
    login_user(staff_user)
    update_user(Faker::Name.first_name, Faker::Name.last_name)
    user_sees_success_message('The user was successfully updated.')
  end

  scenario 'updates a user successfully with a valid first name and last name' do
    login_user(user)
    update_user(Faker::Name.first_name, Faker::Name.last_name)
    user_sees_success_message('The user was successfully updated.')
  end

  scenario 'changes a users administrative rights if user is staff' do
    login_user(staff_user)
    update_user(Faker::Name.first_name, Faker::Name.last_name, true)
    user_sees_success_message('The user was successfully updated.')
  end

  def update_user(first_name, last_name, is_staff=false)
    visit edit_user_path(user)

    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name

    if is_staff
      check('Is staff')
    end

    click_button 'Update User'
  end

end
