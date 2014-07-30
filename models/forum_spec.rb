require 'spec_helper'

describe Forum do
  it "is valid if all parameters match" do
    build(:forum).should be_valid
  end

  it { should have_many(:topics).dependent(:destroy) }

  it { should belong_to(:category) }

  it { should ensure_length_of(:name).is_at_least(1).is_at_most(50) }

  it { should ensure_length_of(:description).is_at_least(10) }

  it { should validate_numericality_of(:order).only_integer }

  it { should ensure_inclusion_of(:order).in_range(0..50) }

end
