require 'spec_helper'

describe CategoriesController do
  let(:category) { create(:category) }

  describe "GET index" do
    it "should return a list of categories" do
    	visit root_path
      assigns(:categories).should == @categories
    end
  end

  describe "GET new" do
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
    let(:staff_user) { create(:user, is_staff: true) }
    let(:user) { create(:user) }

    context 'as staff' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should create a category" do
        @params = { name: Faker::Name.title, order: 10 }

        post :create, { category: @params }
      end

      it { should permit(:name, :order).for(:create) }
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
      let(:category) { create(:category) }
      let(:staff_user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = staff_user.id

        get :edit, { id: category }
      end

      it { should render_template('edit') }
    end

    context 'as not owner nor staff' do
      let(:category) { create(:category) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id

        get :edit, { id: category }
      end

      it { should redirect_to(root_path) }
    end

    context 'as outlogged' do
      let(:category) { create(:category) }

      before do
        get :edit, { id: category }
      end

      it { should redirect_to(session_path) }
    end
  end

  describe "POST update" do
    let(:category) { create(:category) }
    let(:user) { create(:user) }
    let(:staff_user) { create(:user, is_staff: true) }

    context 'as staff' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should update the category" do
        @params = { name: Faker::Name.title, order: 1 }

        patch :update, { id: category, category: @params }
      end
    end

    context 'as staff but invalid parameters' do
      before do
        session[:user_id] = staff_user.id
      end

      it "should not update the category" do
        @params = { name: nil, order: 2 }

        patch :update, { id: category, category: @params }

        category.name.should_not eql @params[:name]
      end
    end

    context 'as not staff' do

      before do
        session[:user_id] = user.id
      end

      it "should not update the category" do
        @params = { name: Faker::Name.title, order: 12 }

        patch :update, { id: category, category: @params}

        category.name.should_not eql @params[:name]

        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE destroy" do
    context "with permission to destroy a category" do
      let!(:category) { create(:category) }
      let(:user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = user.id
      end

      it "destroys the requested category" do
        expect {
          delete :destroy, { id: category }
        }.to change(Category, :count).by(-1)

        response.should redirect_to(root_path)
      end
    end

    context "without permission to destroy a category" do
      let(:category) { create(:category) }
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "should redirect to root_path" do
        delete :destroy, { id: category }

        response.should redirect_to(root_path)
      end
    end
  end
end
