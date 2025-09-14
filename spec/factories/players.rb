FactoryBot.define do
  factory :player do
    user { nil }
    game { nil }
    position { 1 }
    wind { "MyString" }
    hand { "MyText" }
    score { 1 }
  end
end
