require 'spec_helper'

describe Notification do
  it 'is valid if all parameters match' do
    build(:notification).should be_valid
  end

  it { should belong_to(:topic) }
  it { should belong_to(:receiver).class_name('User') }
  it { should belong_to(:sender).class_name('User') }
end
