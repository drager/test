require 'faker'

FactoryGirl.define do
  factory :forum do 
    name {Faker::Name.title}
    association :category
    description {Faker::Lorem.paragraph}
  end
end
