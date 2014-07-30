require 'spec_helper'
require 'faker'

feature 'Update topic' do
  let(:category) { create(:category) }
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:staff_user) { create(:user, is_staff: true) }
  let(:topic) { create(:topic, user: user) }

  scenario 'cannot edit a topic if not owner' do
    login_user(other_user)
    visit edit_forum_topic_path(forum, topic)
    current_path.should == forum_topic_path(forum, topic)
  end

  scenario 'can edit a topic if user is staff' do
    login_user(staff_user)
    update_topic('Third World', Faker::Lorem.paragraph)
    user_sees_success_message('Topic was successfully updated.')
  end

  scenario 'updates a topic successfully with a valid name and bodytext' do
    login_user(user)
    update_topic('Another World', Faker::Lorem.paragraph)
    user_sees_success_message('Topic was successfully updated.')
  end

  scenario 'notifies the user if the name is too short' do
    login_user(user)
    update_topic(nil, Faker::Lorem.paragraph)
    user_sees_error_message('Name is too short (minimum is 6 characters)')
  end

  scenario 'notifies the user if the bodytext is too short' do
    login_user(user)
    update_topic('test-name', nil)
    user_sees_error_message('Posts bodytext is too short (minimum is 20 characters)')
  end

  def update_topic(name, bodytext)
    visit edit_forum_topic_path(forum, topic)
    
    fill_in 'Name', with: name
    fill_in 'Message', with: bodytext

    click_button 'Update Topic'
    #puts "#{page.html.inspect}"
  end

end
