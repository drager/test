require 'spec_helper'
require 'faker'

describe UsersController do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  context 'GET index' do
    it "should return a list of users order by created_by DESC" do
      get :index, {}
      # assigns(:users).should == @users
      assigns(:users).should eq([user2, user1])
    end
  end

  context 'with permission to update an users information' do
    let!(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    context 'when updating first name' do
      it 'should update the first name successfully' do
        @params = { first_name: Faker::Name.first_name }
        put :update, { id: session[:user_id], user: @params }

        user.reload

        user.first_name.should eql @params[:first_name]
      end
    end

    context 'when updating last name' do
      it 'should update the last name successfully' do
        @params = { last_name: Faker::Name.last_name }
        put :update, { id: session[:user_id], user: @params }

        user.reload

        user.last_name.should eql @params[:last_name]
      end
    end

    context 'when updating the email' do
      it 'should update the email successfully' do
        @params = { email: Faker::Internet.email }
        put :update, { id: session[:user_id], user: @params }

        user.reload

        user.email.should eql @params[:email]
      end
    end

    context 'when updating the password' do
      it 'should update the password successfully' do

        @params = { password: Faker::Internet.password }
        put :update, { id: session[:user_id], user: @params }

        user.reload

        expect(assigns(:user)).to be_valid

        expect(assigns(:user).password).to eq(@params[:password])

      end
    end

    context 'when trying to update the email with nil value' do
      it 'should not update the value' do
        @params = { email: nil }

        put :update, { id: session[:user_id], user: @params}

        user.reload

        user.email.should_not eql @params[:email]
      end
    end
  end

  context 'without permission to update an users administrative rights' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    context 'when trying to check is_staff' do
      it 'should not update the value' do
        @params = { is_staff: true}

        put :update, { id: session[:user_id], user: @params}

        user.reload

        user.is_staff.should_not eql @params[:is_staff]
      end
    end
  end

  context 'with permission to update an users administrative rights' do
    let(:user) { create(:user) }
    let(:staff_user) { create(:user, is_staff: true) }

    before do
      session[:user_id] = staff_user.id
    end

    context 'when trying to check is_staff' do
      it 'should set is_staff to true' do
        @params = { is_staff: true}

        put :update, { id: user.id, user: @params}

        user.reload

        user.is_staff.should eql @params[:is_staff]
      end
    end
  end

  context 'as outlogged' do
    let(:user) { create(:user) }

    it 'should redirect to the called users path' do
      @params = { first_name: Faker::Name.first_name }

      put :update, { id: user.id, user: @params }

      response.should redirect_to(user_path(user))

      user.reload

      user.first_name.should_not eql @params[:first_name]
    end
  end
end
