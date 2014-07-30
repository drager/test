require 'spec_helper'

describe TopicsController do

=begin
  # Changed some code so no longed needed, action removed.
  context "GET index" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }

    it "should redirect to forum_path" do
      get :index, { forum_id: forum }

      response.should redirect_to(forum_path(forum))
    end
  end
=end

  context "without permission to lock/unlock a topic" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    context "when locking" do
      it "should redirect to forum_topic_path" do
        put :lock, { forum_id: forum, topic_id: topic }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end

    context "when unlocking" do
      it "should redirect to forum_topic_path" do
        put :unlock, { forum_id: forum, topic_id: topic }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end

  context "with permission to destroy a topic" do
    let(:forum) { create(:forum) }
    let!(:topic) { create(:topic) }
    let(:user) { create(:user, is_staff: true) }

    before do
      session[:user_id] = user.id
    end

    it "destroys the requested topic" do
      expect {
        delete :destroy, { forum_id: forum, id: topic }
      }.to change(Topic, :count).by(-1)

      response.should redirect_to(forum_path(forum))

    end
  end

  context "without permission to destroy a topic" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    it "should redirect to forum_topic_path" do
      delete :destroy, { forum_id: forum, id: topic }

      response.should redirect_to(forum_topic_path(forum, topic))
    end
  end

  context "without permission to stick/unstick a topic" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    context "when sticking" do
      it "should redirect to forum_topic_path" do
        put :stick, { forum_id: forum, topic_id: topic }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end

    context "when unsticking" do
      it "should redirect to forum_topic_path" do
        put :unstick, { forum_id: forum, topic_id: topic }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end

  context "with permission to move a topic" do
    let(:forum) { create(:forum) }
    let(:new_forum) { create(:forum, name: "Python") }
    let(:topic) { create(:topic) }
    let(:staff_user) { create(:user, is_staff: true) }

    before do
      session[:user_id] = staff_user.id
    end

    it "should update the topics forum_id and redirect to forum_topic_path" do
      get :move, { forum_id: forum, topic_id: topic }

      @params = { forum: new_forum.id }

      patch :move, { forum_id: forum, topic_id: topic, topic: @params }

      topic.reload

      topic.forum_id.should eql @params[:forum]

      response.should redirect_to(forum_topic_path(new_forum, topic))
    end
  end

  context "without permission to move a topic" do
    let(:forum) { create(:forum) }
    let(:new_forum) { create(:forum, name: "Python") }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    it "should redirect to forum_topic_path" do
      get :move, { forum_id: forum, topic_id: topic }

      @params = { forum: new_forum.id }

      patch :move, { forum_id: forum, topic_id: topic, topic: @params }

      topic.reload

      topic.forum_id.should_not eql @params[:forum]

      response.should redirect_to(forum_topic_path(forum, topic))
    end
  end

  context "with permission to subscribe to a topic" do
    let(:user) { create(:user) }
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }

    before do
      session[:user_id] = user.id
    end

    it "should subscribe to the topic and redirect" do
      post :subscribe, { forum_id: forum, topic_id: topic}

      response.should redirect_to(forum_topic_path(forum, topic))

      topic.subscriptions.last.user.should eql(user)
    end

    it "can only subscribe once per topic" do
      expect {
        2.times { post :subscribe, { forum_id: forum, topic_id: topic} }
      }.to change { topic.subscriptions.count }.from(topic.subscriptions.count).by(1)

      response.should redirect_to(forum_topic_path(forum, topic))
    end
  end

  context "with permission to unsubscribe to a topic" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }

    before do
      session[:user_id] = user.id
    end

    it "should unsubscribe to the topic and redirect" do
      topic.subscriptions.create(user: other_user)
      topic.subscriptions.create(user: user)
      topic.subscriptions.last.user.should eql(user)

      post :unsubscribe, { forum_id: forum, topic_id: topic}

      response.should redirect_to(forum_topic_path(forum, topic))

      topic.subscriptions.last.user.should_not eql(user)
    end

    it "can only unsubscribe to a topic if user has a subscription" do
      expect {
        post :unsubscribe, { forum_id: forum, topic_id: topic}
      }.not_to change { topic.subscriptions.count }.from(topic.subscriptions.count).by(1)

      response.should redirect_to(forum_topic_path(forum, topic))
    end
  end

  context "GET RSS feed" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic, forum: forum) }

    it "shound return an RSS feed" do
      get :feed, format: "rss"
      response.should be_success
      response.content_type.should eq("application/rss+xml")
    end
  end

  describe "POST update" do
    let(:forum) { create(:forum) }
    let!(:topic) { create(:topic) }
    let(:user) { create(:user) }
    let(:staff_user) { create(:user, is_staff: true) }

    context "as staff" do
      before do
        session[:user_id] = staff_user.id
      end

      it "should update a topic" do
        @params = { name: Faker::Name.title, bodytext: Faker::Lorem.paragraph }

        patch :update, { forum_id: forum, id: topic, topic: @params }

        topic.reload

        topic.name.should eql @params[:name]
      end
    end

    context "as owner but invalid parameters" do
      before do
        session[:user_id] = staff_user.id
      end

      it "should not update a topic" do

        @params = { name: nil, bodytext: Faker::Lorem.paragraph }

        patch :update, { forum_id: forum, id: topic, topic: @params }

        topic.reload

        topic.name.should_not eql @params[:name]
      end
    end

    context "as not owner nor staff" do

      before do
        session[:user_id] = user.id
      end

      it "should not update a post" do
        @params = { name: Faker::Name.title, bodytext: Faker::Lorem.paragraph }

        patch :update, { forum_id: forum, id: topic, topic: @params }

        topic.name.should_not eql @params[:name]

        topic.reload

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end

  describe "GET show page" do
    let(:forum) { create(:forum) }
    let!(:topic) { create(:topic) }

    context "when page is out range" do
      it "should redirect to forum_topic_path" do
        get :show, { forum_id: forum, id: topic, page: 200 }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end
end
