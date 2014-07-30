require 'spec_helper'
require 'faker'

feature 'Sticking topic' do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }
  let(:staff_user) { create(:user, is_staff: true) }
  let(:topic) { create(:topic, user: user) }

  scenario 'user that is staff can stick/unstick a topic' do
    login_user(staff_user)

    visit forum_topic_path(forum, topic)
    click_link 'Stick topic'
    user_sees_success_message('Topic has now been sticky!')

    current_path.should == forum_topic_path(forum, topic)

    visit forum_topic_path(forum, topic)
    click_link 'Unstick topic'
    user_sees_success_message('Topic has now been unsticky!')
  end
end
