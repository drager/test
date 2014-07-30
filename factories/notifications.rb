
FactoryGirl.define do
  factory :notification do
    association :topic
    association :receiver, factory: :user
    sender { receiver }
    read false
  end
end
