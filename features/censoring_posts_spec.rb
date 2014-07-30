require 'spec_helper'
require 'faker'

feature 'Censoring post' do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }
  let(:staff_user) { create(:user, is_staff: true) }
  let(:topic) { create(:topic, user: user) }
  let(:post) { create(:post, topic: topic) }

  scenario 'user that is staff can censor/uncensor a post' do
    login_user(staff_user)

    visit forum_topic_path(forum, topic)
    click_link 'Censor post'
    user_sees_success_message('Post is now censored!')

    current_path.should == forum_topic_path(forum, topic)

    visit forum_topic_path(forum, topic)
    click_link 'Uncensor post'
    user_sees_success_message('Post is now uncensored!')
  end
end
