require 'spec_helper'

describe PostsController do

  context 'GET new' do
    context 'as authorized' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:user) { create(:user) }
      let(:post) { create(:post, topic: topic) }

      before do
        session[:user_id] = user.id
      end

      it 'should redirect to forum_topic_path' do
        get :new, { forum_id: forum, topic_id: topic, post_id: post }

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end

    context 'as unauthorized' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:post) { create(:post, topic: topic) }

      it 'should redirect to session_path' do
        get :new, { forum_id: forum, topic_id: topic, post_id: post }

        response.should redirect_to(session_path)
      end
    end
  end

  context 'without permission to censor/uncensor a post' do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }
    let(:post) { create(:post, topic: topic) }

    before do
      session[:user_id] = user.id
    end

    it 'should redirect to forum_topic_path' do
      put :censor, { forum_id: forum, topic_id: topic, post_id: post }

      response.should redirect_to(forum_topic_path(forum, topic))

      page.html.should_not match('Post is now censored!')

      put :uncensor, { forum_id: forum, topic_id: topic, post_id: post }

      response.should redirect_to(forum_topic_path(forum, topic))

      page.html.should_not match('Post is now uncensored!')
    end
  end

  context 'GET edit' do
    context 'as owner of post' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:user) { create(:user) }
      let(:post) { create(:post, topic: topic, user: user) }

      before do
        session[:user_id] = user.id

        get :edit, { forum_id: forum, topic_id: topic, id: post }
      end

      it { should render_template('edit') }
    end

    context 'as staff' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:user) { create(:user) }
      let(:staff_user) { create(:user, is_staff: true) }
      let(:post) { create(:post, topic: topic, user: user) }

      before do
        session[:user_id] = user.id

        get :edit, { forum_id: forum, topic_id: topic, id: post }
      end

      it { should render_template('edit') }
    end

    context 'as not owner nor staff' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:user) { create(:user) }
      let(:post) { create(:post, topic: topic) }

      before do
        session[:user_id] = user.id

        get :edit, { forum_id: forum, topic_id: topic, id: post }
      end

      it { should redirect_to(forum_topic_path(forum, topic)) }
    end

    context 'as outlogged' do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic) }
      let(:post) { create(:post, topic: topic) }

      before do
        get :edit, { forum_id: forum, topic_id: topic, id: post }
      end

      it { should redirect_to(session_path) }
    end
  end

  describe "POST update" do
    let(:forum) { create(:forum) }
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }
    let(:post) { create(:post, topic: topic) }
    let(:staff_user) { create(:user, is_staff: true) }

    context 'as staff' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should update a post" do
        @params = { bodytext: Faker::Lorem.paragraph }

        patch :update, { forum_id: forum, topic_id: topic, id: post, post: @params }

        post.reload

        post.bodytext.should eql @params[:bodytext]
      end
    end

    context 'as owner but invalid parameters' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should not update a post" do
        @params = { bodytext: '12' }

        patch :update, { forum_id: forum, topic_id: topic, id: post, post: @params }

        post.reload

        post.bodytext.should_not eql @params[:bodytext]
      end
    end

    context 'as not owner nor staff' do

      before do
        session[:user_id] = user.id
      end

      it "should not update a post" do
        @params = { bodytext: Faker::Lorem.paragraph }
        
        patch :update, { forum_id: forum, topic_id: topic, id: post, post: @params}

        post.reload

        post.bodytext.should_not eql @params[:bodytext]

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end

  describe "DELETE destroy" do
    context "with permission to destroy a post" do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic, forum: forum) }
      let!(:post) { create(:post, topic: topic) }
      let(:user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = user.id
      end

      it "destroys the requested post" do
        expect {
          delete :destroy, { forum_id: forum, topic_id: topic, id: post }
        }.to change(Post, :count).by(-1)

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end

    context "without permission to destroy a post" do
      let(:forum) { create(:forum) }
      let(:topic) { create(:topic, forum: forum) }
      let!(:post) { create(:post, topic: topic) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "should not destroy the post and redirect" do
        expect {
          delete :destroy, { forum_id: forum, topic_id: topic, id: post }
        }.not_to change(Post, :count).by(-1)

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end

    context "trying to destory the first post" do
      let(:forum) { create(:forum) }
      let!(:topic) { create(:topic, forum: forum, posts_attributes: [bodytext: "This is a brand new post!"]) }
      #let!(:post) { create(:post, topic: topic) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "should not destroy the post and redirect" do
        expect {
          delete :destroy, { forum_id: forum, topic_id: topic, id: topic.posts.first }
        }.not_to change(Post, :count).by(-1)

        response.should redirect_to(forum_topic_path(forum, topic))
      end
    end
  end
end
