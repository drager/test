require 'spec_helper'
require 'faker'

feature 'Create topic' do
  let(:category) { create(:category) }
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }

  background do
    @email = 'ellen.u@lnu.se'
    @password = 'test123'
    @user = create(:user, username: 'ellen.u', email: @email, password: @password, password_confirmation: @password)
  end

  scenario 'cannot create a new topic if logged out' do
    visit new_forum_topic_path(forum)
    current_path.should == session_path
  end

  scenario 'creates a topic successfully with a valid name and bodytext' do
    login_user(@user)
    create_topic('Hello World!', Faker::Lorem.paragraph)
    current_path.should == forum_topic_path(forum, Topic.find_by(name: 'Hello World!'))
    user_sees_success_message('Topic was successfully created.')
  end

  scenario 'notifies the user if the name is too short' do
    login_user(@user)
    create_topic(nil, '12345678912345678912')
    user_sees_error_message('Name is too short (minimum is 6 characters)')
  end

  scenario 'notifies the user if the bodytext is too short' do
    login_user(@user)
    create_topic('test-name', '1234567891234567891')
    user_sees_error_message('Posts bodytext is too short (minimum is 20 characters)')
  end

  def create_topic(name, bodytext)
    visit new_forum_topic_path(forum)
    fill_in 'Name', with: name
    fill_in 'Message', with: bodytext
    click_button 'Create Topic'
  end

end
