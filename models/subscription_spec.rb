require 'spec_helper'

describe Subscription do
  it 'is valid if all parameters match' do
    build(:subscription).should be_valid
  end

  it { should belong_to(:topic) }
  it { should belong_to(:user) }
end

