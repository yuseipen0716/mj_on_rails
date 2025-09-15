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
    game { nil }
    player { nil }
    event_type { "MyString" }
    data { "MyText" }
  end
end
