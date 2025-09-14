FactoryBot.define do
  factory :dora_indicator do
    game { nil }
    player { nil }
    tile { "MyString" }
    position { 1 }
    source { 1 }
    turn_number { 1 }
    action_sequence { 1 }
  end
end
