# == Schema Information
#
# Table name: games
#
#  id             :integer          not null, primary key
#  current_player :integer          default(0)
#  status         :integer          default(0), not null
#  title          :string(100)      not null
#  turn           :integer          default(0)
#  wall           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_games_on_created_at  (created_at)
#  index_games_on_status      (status)
#
class Game < ApplicationRecord
end
