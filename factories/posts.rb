require 'faker'

FactoryGirl.define do
  factory :post do
    association :topic
    bodytext {Faker::Lorem.paragraph}
    association :user
  end
end
