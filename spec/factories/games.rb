FactoryBot.define do
  factory :game do
    title { "MyString" }
    status { 1 }
    turn { 1 }
    current_player { 1 }
    wall { "MyText" }
    dora { "MyString" }
  end
end
