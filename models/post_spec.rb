require 'spec_helper'

describe Post do
  let(:topic) { create(:topic) }
  let(:post) { create(:post, topic: topic) }
  let(:notification) { create(:notification, receiver: user) }
  let(:user) { create(:user) }

  it "is valid if all parameters match" do
    build(:post).should be_valid
  end

  it { should belong_to(:topic) }
  it { should belong_to(:user) }

  it { should ensure_length_of(:bodytext).is_at_least(20) }

  it 'notifies all the users with a subscription to the topic' do
    topic.subscriptions.create(user: user)

    post.notify_users(topic.subscriptions)

    notification.receiver.should eq(topic.subscriptions.last.user)
  end

end
