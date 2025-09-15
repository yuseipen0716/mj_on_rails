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
    game { nil }
    player { nil }
    tile { "MyString" }
    position { 1 }
    source { 1 }
    turn_number { 1 }
    action_sequence { 1 }
  end
end
