require 'spec_helper'

describe Topic do
    let(:topic) { create(:topic) }
    let(:user) { create(:user, is_staff: true) }

    it 'is valid if all parameters match' do
      build(:topic).should be_valid
    end

    it { should have_many(:posts).dependent(:destroy) }

    it { should belong_to(:forum) }
    it { should belong_to(:user) }

    it { should ensure_length_of(:name).is_at_least(6).is_at_most(50) }

    it { should accept_nested_attributes_for(:posts) }

    context 'helper methods' do

      it 'checks for topic owner' do
        topic.is_owner_or_staff?(topic.user).should be_true
      end

      it 'checks if user is staff?' do
        topic.is_owner_or_staff?(user).should be_true
      end

    end
end
