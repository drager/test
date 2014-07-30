require 'spec_helper'

describe Category do
  it "is valid if all parameters match" do
    build(:category).should be_valid
  end

  it { should have_many(:forums).dependent(:destroy) }

  it { should ensure_length_of(:name).is_at_least(6).is_at_most(50) }

  it { should validate_numericality_of(:order).only_integer }

  it { should ensure_inclusion_of(:order).in_range(0..50) }

end
