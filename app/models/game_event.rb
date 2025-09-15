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
class GameEvent < ApplicationRecord
  belongs_to :game
  belongs_to :player

  enum event_type: {
    # 基本アクション
    draw_tile: 0,      # ツモ
    discard_tile: 1,   # 打牌

    # 鳴き
    pon: 2,           # ポン
    chi: 3,           # チー
    minkan: 4,        # 明槓
    ankan: 5,         # 暗槓
    kakan: 6,         # 加槓

    # あがり
    ron: 7,           # ロン
    tsumo: 8,         # ツモあがり

    # 特殊アクション
    reach: 9,        # リーチ
    pass: 10,         # パス（見逃し）

    # ゲーム進行
    game_start: 11,   # ゲーム開始
    turn_start: 12,   # 巡開始
    draw: 13,    # 流局
    game_end: 14      # ゲーム終了
  }
end
