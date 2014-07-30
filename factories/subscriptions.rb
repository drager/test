
FactoryGirl.define do
  factory :subscription do
    association :topic
    association :user
  end
end
