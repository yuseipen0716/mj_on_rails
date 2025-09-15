# == Schema Information
#
# Table name: dora_indicators
#
#  id              :integer          not null, primary key
#  action_sequence :integer          default(0), not null
#  position        :integer          not null
#  source          :integer          default(0), not null
#  tile            :string(10)       not null
#  turn_number     :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_id         :integer          not null
#  player_id       :integer
#
# Indexes
#
#  index_dora_indicators_on_game_id                  (game_id)
#  index_dora_indicators_on_game_id_and_created_at   (game_id,created_at)
#  index_dora_indicators_on_game_id_and_position     (game_id,position) UNIQUE
#  index_dora_indicators_on_game_id_and_turn_number  (game_id,turn_number)
#  index_dora_indicators_on_player_id                (player_id)
#  index_dora_indicators_on_source                   (source)
#
# Foreign Keys
#
#  game_id    (game_id => games.id)
#  player_id  (player_id => players.id)
#
FactoryBot.define do
  factory :dora_indicator do
    association :game
    player { nil }
    tile { "5m" }
    position { 1 }
    source { :initial }
    turn_number { 0 }
    action_sequence { 0 }

    trait :initial_dora do
      source { :initial }
      position { 1 }
      turn_number { 0 }
    end

    trait :kan_dora do
      source { :kan }
      position { 2 }
      turn_number { 5 }
      action_sequence { 3 }
    end

    trait :ura_dora do
      source { :ura }
      position { 1 }
    end

    factory :initial_dora_indicator, traits: [:initial_dora]
    factory :kan_dora_indicator, traits: [:kan_dora]
    factory :ura_dora_indicator, traits: [:ura_dora]
  end
end
