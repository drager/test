require 'spec_helper'
require 'faker'

feature 'Create post' do
  let(:category) { create(:category) }
  let(:forum) { create(:forum) }
  let(:topic) { create(:topic) }
  let(:user) { create(:user) }

  scenario 'cannot create a new post if logged out' do
    visit new_forum_topic_path(forum)
    current_path.should == session_path
  end

  scenario 'creates a post successfully with a valid bodytext' do
    login_user(user)
    create_post(Faker::Lorem.paragraph)
    current_path.should == forum_topic_path(forum, topic)
    user_sees_success_message('Post was successfully created.')
  end

  scenario 'notifies the user if the bodytext is too short' do
    login_user(user)
    create_post(nil)
    user_sees_error_message('Posts bodytext is too short (minimum is 20 characters)')
  end

  def create_post(bodytext)
    visit forum_topic_path(forum, topic)
    fill_in 'Message', with: bodytext
    click_button 'Create Post'
  end

end
