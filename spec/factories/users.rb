FactoryBot.define do
  factory :user do
    email { "test_user@gmail.com" }
    password { "password"}
    password_confirmation { "password" }
    confirmed_at { nil }
    unconfirmed_email { nil }
  end
end
