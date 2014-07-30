require 'spec_helper'

describe NotificationsController do

  describe 'GET index' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:notification) { create(:notification, receiver: user) }

    context 'as authorized' do
      before do
        session[:user_id] = user
      end

      it 'returns http success and a list of users unread notifications' do
        get :index
        response.should be_success
        expect(assigns(:notifications).to_a).to eq(user.notifications.to_a)
      end
    end

    context 'as unauthorized' do

      it 'should redirect_to session_path' do
        get :index
        response.should redirect_to(session_path)
      end
    end
  end

  describe 'GET read' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:notification) { create(:notification, receiver: user) }

    context 'as authorized' do
      before do
        session[:user_id] = user
      end

      it 'returns http success and a list of users read notifications' do
        get :read
        response.should be_success
        expect(assigns(:notifications).to_a).to eq(user.notifications.to_a)
      end
    end

    context 'as unauthorized' do

      it 'should redirect_to session_path' do
        get :read
        response.should redirect_to(session_path)
      end
    end
  end

  describe 'mark as read' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context 'as authorized' do
      before do
        session[:user_id] = user
      end

      context 'when notification is unread' do
        let!(:notification) { create(:notification, receiver: user) }

        it 'should change the notification_count from 1 to 0' do
          expect {
            put :mark_as_read, { id: notification }
          }.to change { controller.send(:notification_count) }.from(1).to(0)

          response.should redirect_to(notifications_path)
        end
      end

      context 'when notification is already read' do
        let!(:notification) { create(:notification, receiver: user, read: true) }

        it 'should not change the notification_count' do
          expect {
            put :mark_as_read, { id: notification }
          }.to_not change { controller.send(:notification_count) }.from(1).to(0)

          response.should redirect_to(notifications_path)
        end
      end

      context 'when notification is not owned by user' do
        let!(:notification) { create(:notification, receiver: other_user) }

        it 'should not change the notification_count' do
          expect {
            put :mark_as_read, { id: notification }
          }.to_not change { controller.send(:notification_count) }.from(1).to(0)

          response.should redirect_to(notifications_path)
        end
      end
    end

    context 'as unauthorized' do
      let!(:notification) { create(:notification, receiver: user) }

      it 'should redirect_to session_path and not change the notification_count' do
        expect {
          put :mark_as_read, { id: notification }
        }.to_not change { controller.send(:notification_count) }.from(1).to(0)

        response.should redirect_to(session_path)
      end
    end
  end
end
