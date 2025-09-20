# == Schema Information
#
# Table name: games
#
#  id             :integer          not null, primary key
#  current_player :integer          default(0)
#  status         :integer          default(0), not null
#  title          :string(100)      not null
#  turn           :integer          default(0)
#  main_wall      :text             # 通常の山（最大122枚）
#  locked_wall    :text             # 王牌（ドラ表示牌・嶺上牌など。14枚固定）
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_games_on_created_at  (created_at)
#  index_games_on_status      (status)
#
class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :users, through: :players
  has_many :game_events, dependent: :destroy
  has_many :dora_indicators, -> { order(:position) }, dependent: :destroy

  enum status: {
    waiting: 0,    # プレイヤー募集中
    playing: 1,    # ゲーム進行中
    finished: 2    # ゲーム終了
  }

  serialize :main_wall, Array
  serialize :locked_wall, Array
end
