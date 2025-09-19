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
class DoraIndicator < ApplicationRecord
  belongs_to :game
  belongs_to :player

  enum source: {
    initial: 0,  # 開始時のドラ
    minkan: 1,   # 明槓によるドラ
    ankan: 2,    # 暗槓によるドラ
    kakan: 3     # 加槓によるドラ
  }
end
