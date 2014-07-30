require 'spec_helper'

describe PagesController do

  describe "GET admin" do
    context "as staff" do
      let(:staff_user) { create(:user, is_staff: true) }

      before do
        session[:user_id] = staff_user.id
      end

      it "returns http success" do
        get :admin
        response.should be_success
      end
    end

    context "as logged in but not staff" do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "redirects to root_path" do
        get :admin
        response.should redirect_to(root_path)
      end
    end

    context "as outlogged" do
      it "redirects to session_path" do
        get :admin
        response.should redirect_to(session_path)
      end
    end
  end

end
