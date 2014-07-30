require 'spec_helper'
require 'faker'

feature 'Moving topic' do
  let(:forum) { create(:forum) }
  let!(:new_forum) { create(:forum, name: 'Python') }
  let(:staff_user) { create(:user, is_staff: true) }
  let(:topic) { create(:topic) }

  scenario 'user that is staff can move a topic' do
    login_user(staff_user)

    visit forum_topic_path(forum, topic)

    click_link 'Move topic'

    current_path.should == forum_topic_move_path(forum, topic)

    select 'Python', from: 'Forum'

    click_button 'Move topic'

    current_path.should == forum_topic_path(new_forum, topic)

    user_sees_success_message('The topic has now been moved to another forum!') # something like that…
  end
end
