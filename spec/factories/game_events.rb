FactoryBot.define do
  factory :game_event do
    game { nil }
    player { nil }
    event_type { "MyString" }
    data { "MyText" }
  end
end
