require 'spec_helper'
require 'faker'

feature 'Subscribe to topic' do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }
  let(:topic) { create(:topic) }

  context 'logged in' do
    before do
      login_user(user)
    end

    scenario 'can subscribe to a topic' do
      visit forum_topic_path(forum, topic)
      click_link 'Subscribe'

      user_sees_success_message('Subscription added successfully!')
    end

    scenario 'can unsubscribe from a subscribed topic' do
      topic.subscriptions.create(user: user)

      visit forum_topic_path(forum, topic)

      click_link 'Unsubscribe'

      user_sees_success_message('Subscription removed successfully!')
    end
  end
end
