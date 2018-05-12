FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_email_#{n}@test.com" }
    name 'test_user'
    password 'password'
    password_confirmation 'password'
  end
end
