require 'faker'

FactoryGirl.define do
  factory :topic do
    association :forum
    name {Faker::Name.title}
    association :user
    posts_attributes { [bodytext: "This is a brand new post"] }
  end
end
