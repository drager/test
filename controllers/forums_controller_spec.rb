require 'spec_helper'
require 'faker'

describe ForumsController do
  let!(:category) { create(:category) }
  let(:forum) { create(:forum) }

  describe "GET index" do
    it "should redirect to root_path" do
      get :index
      response.should redirect_to(root_path)
    end
  end

  describe "GET show" do
    let(:topic) { create(:topic) }
    let(:forum) { create(:forum) }

    it "should return a list of topics" do
      get :show, { id: forum }
      expect(assigns(:topics).to_a).to eq(forum.topics.to_a)
    end
  end

  describe "GET new" do
    let!(:category) { create(:category) }
    let(:staff_user) { create(:user, is_staff: true) }
    let(:user) { create(:user) }

    context 'as staff' do

      before do
        session[:user_id] = staff_user.id

        get :new
      end

      it { should render_template('new') }
    end

    context 'as not staff' do

      before do
        session[:user_id] = user.id

        get :new
      end

      it { should redirect_to(root_path) }
    end
  end

  describe "POST create" do
    let!(:category) { create(:category) }
    let(:staff_user) { create(:user, is_staff: true) }
    let(:user) { create(:user) }

    context 'as staff' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should create a forum" do
        @params = { name: Faker::Name.title, description: Faker::Lorem.paragraph, category_id: category.id }

        post :create, { forum: @params }
      end

      it { should permit(:name, :description, :order, :category_id).for(:create) }
    end

    context 'as not staff' do

      before do
        session[:user_id] = user.id

        get :create
      end

      it { should redirect_to(root_path) }
    end
  end

  context 'GET edit' do
    context 'as staff' do
      let(:forum) { create(:forum) }
      let(:staff_user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = staff_user.id

        get :edit, { id: forum }
      end

      it { should render_template('edit') }
    end

    context 'as not owner nor staff' do
      let(:forum) { create(:forum) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id

        get :edit, { id: forum }
      end

      it { should redirect_to(root_path) }
    end

    context 'as outlogged' do
      let(:forum) { create(:forum) }

      before do
        get :edit, { id: forum }
      end

      it { should redirect_to(session_path) }
    end
  end

  describe "POST update" do
    let(:category) { create(:category) }
    let(:forum) { create(:forum) }
    let(:user) { create(:user) }
    let(:staff_user) { create(:user, is_staff: true) }

    context 'as staff' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should update the forum" do
        @params = { name: Faker::Name.title, description: Faker::Lorem.paragraph, category_id: category.id }

        patch :update, { id: forum, forum: @params }
      end
    end

    context 'as staff but invalid parameters' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should not update the forum" do
        @params = { name: Faker::Name.title, description: nil, category_id: category.id }

        patch :update, { id: forum, forum: @params }

        forum.name.should_not eql @params[:name]
      end
    end

    context 'as not staff' do

      before do
        session[:user_id] = user.id
      end

      it "should not update the forum" do
        @params = { name: Faker::Name.title, description: Faker::Lorem.paragraph, category_id: category.id }

        patch :update, { id: forum, forum: @params}

        forum.description.should_not eql @params[:description]

        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE destroy" do
    context "with permission to destroy a forum" do
      let!(:forum) { create(:forum) }
      let(:user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = user.id
      end

      it "destroys the requested forum" do
        expect {
          delete :destroy, { id: forum }
        }.to change(Forum, :count).by(-1)

        response.should redirect_to(root_path)
      end
    end

    context "without permission to destroy a forum" do
      let(:forum) { create(:forum) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "should redirect to root_path" do
        delete :destroy, { id: forum }

        response.should redirect_to(root_path)
      end
    end
  end
end
