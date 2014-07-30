require 'faker'

FactoryGirl.define do
  factory :user do 
    email {Faker::Internet.email}
    username {Faker::Internet.user_name(6)}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    password 'test123'
    password_confirmation 'test123'
  end
end
