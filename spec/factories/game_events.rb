# == Schema Information
#
# Table name: game_events
#
#  id              :integer          not null, primary key
#  action_sequence :integer          default(0), not null
#  data            :text
#  event_type      :integer          not null
#  turn_number     :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_id         :integer          not null
#  player_id       :integer          not null
#
# Indexes
#
#  index_game_events_on_event_type                (event_type)
#  index_game_events_on_game_id                   (game_id)
#  index_game_events_on_game_id_and_created_at    (game_id,created_at)
#  index_game_events_on_game_id_and_event_type    (game_id,event_type)
#  index_game_events_on_game_id_and_turn_number   (game_id,turn_number)
#  index_game_events_on_player_id                 (player_id)
#  index_game_events_on_player_id_and_event_type  (player_id,event_type)
#
# Foreign Keys
#
#  game_id    (game_id => games.id)
#  player_id  (player_id => players.id)
#
FactoryBot.define do
  factory :game_event do
    association :game
    association :player
    event_type { :draw_tile }
    turn_number { 1 }
    action_sequence { 1 }
    data { { tile: "1m" }.to_json }

    trait :draw_tile do
      event_type { :draw_tile }
      data { { tile: "5m" }.to_json }
    end

    trait :discard_tile do
      event_type { :discard_tile }
      data { { tile: "9p" }.to_json }
    end

    trait :pon do
      event_type { :pon }
      data { { tiles: [ "3s", "3s", "3s" ], from_player: 1 }.to_json }
    end

    trait :chi do
      event_type { :chi }
      data { { tiles: [ "1p", "2p", "3p" ], from_player: 1 }.to_json }
    end

    trait :ron do
      event_type { :ron }
      data { { winning_tile: "red", han: 3, fu: 30, score: 5800 }.to_json }
    end

    trait :tsumo do
      event_type { :tsumo }
      data { { winning_tile: "1m", han: 2, fu: 40, score: 2600 }.to_json }
    end

    factory :draw_event, traits: [ :draw_tile ]
    factory :discard_event, traits: [ :discard_tile ]
    factory :pon_event, traits: [ :pon ]
    factory :chi_event, traits: [ :chi ]
    factory :ron_event, traits: [ :ron ]
    factory :tsumo_event, traits: [ :tsumo ]
  end
end
