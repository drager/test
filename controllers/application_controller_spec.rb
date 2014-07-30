require 'spec_helper'

describe ApplicationController do
  let(:user) { create(:user) }

  describe '#current_user' do

    context 'with user logged in' do

      before do
        session[:user_id] = user.id
      end

      it 'returns the logged in user' do
        controller.send(:current_user).should eq(user)
      end
    end

    context 'without user logged in' do
      it 'returns nil' do
        controller.send(:current_user).should be_nil
      end
    end

    context 'cant find the user' do
      before do
        session[:user_id] = '#1337'
      end

      it 'returns nil' do
        controller.send(:current_user).should be_nil
      end

      it 'unsets the session[:user_id]' do
        controller.send(:current_user)
        session[:user_id].should be_nil
      end
    end
  end

  describe 'authorize filter' do
    context 'with user logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        controller.send(:authorize).should be_true
      end
    end
  end

  describe '#notification_count' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    context 'when theres any notifications' do
      let!(:notification) { create(:notification, receiver: user) }

      it 'returns the count of unread notifications' do
        controller.send(:notification_count).should eql(1)
      end
    end

    context 'when all the notifications are read' do
      let!(:notification) { create(:notification, receiver: user, read: true) }

      it 'returns the count of unread notifications' do
        controller.send(:notification_count).should eql(0)
      end
    end
  end
end
