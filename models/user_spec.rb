require 'spec_helper'

describe User do
  it "is valid if all parameters match" do
    build(:user).should be_valid
  end

  it { should have_secure_password }

  it { should validate_presence_of(:email) }

  it { should ensure_length_of(:username).is_at_least(3) }

  it { should ensure_length_of(:password).is_at_least(6) }

  it do
    should validate_confirmation_of(:password)
  end

  it { should validate_uniqueness_of(:username) }

  it { should validate_uniqueness_of(:email) }
end
