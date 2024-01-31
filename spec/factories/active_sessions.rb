FactoryBot.define do
  factory :active_session do
    user { nil }
    user_agent { "MyString" }
    ip_address { "MyString" }
    remember_token { "MyString" }
  end
end
