# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(50)       not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unique_id       :string(20)       not null
#
# Indexes
#
#  index_users_on_email      (email) UNIQUE WHERE email IS NOT NULL
#  index_users_on_unique_id  (unique_id) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "プレイヤー#{n}" }
    sequence(:email) { |n| "player#{n}@example.com" }
    password { "password123" }
    sequence(:unique_id) { |n| "#{SecureRandom.alphanumeric(6).upcase}#{1000 + n}" }

    trait :with_email do
      sequence(:email) { |n| "player#{n}@mahjong.com" }
    end

    trait :without_email do
      email { nil }
    end

    trait :with_password do
      password { "password123" }
    end

    trait :without_password do
      password { nil }
    end

    trait :guest do
      email { nil }
      password { nil }
      sequence(:name) { |n| "ゲスト#{n}" }
    end

    factory :user_with_email, traits: [:with_email, :with_password]
    factory :user_without_email, traits: [:without_email, :with_password]
    factory :guest_user, traits: [:guest]
  end
end
