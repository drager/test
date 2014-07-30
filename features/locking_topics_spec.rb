require 'spec_helper'
require 'faker'

feature 'Locking topic' do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }
  let(:staff_user) { create(:user, is_staff: true) }
  let(:topic) { create(:topic, user: user) }

  scenario 'user that is staff can lock/unlock a topic' do
    login_user(staff_user)

    visit forum_topic_path(forum, topic)
    click_link 'Lock topic'
    user_sees_success_message('Topic is now locked!')

    current_path.should == forum_topic_path(forum, topic)

    visit forum_topic_path(forum, topic)
    click_link 'Unlock topic'
    user_sees_success_message('Topic is now unlocked!')
  end

  scenario 'owner of the topic can not lock/unlock it' do
    login_user(user)

    visit forum_topic_path(forum, topic)

    page.should_not have_link('Lock topic')

    page.should_not have_link('Unlock topic')
  end

end
