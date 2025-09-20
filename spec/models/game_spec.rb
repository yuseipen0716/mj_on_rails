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
require 'rails_helper'

RSpec.describe Game, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
