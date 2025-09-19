# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  hand       :text
#  position   :integer          default(0), not null
#  score      :integer          default(25000)
#  wind       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_players_on_game_id               (game_id)
#  index_players_on_game_id_and_position  (game_id,position) UNIQUE
#  index_players_on_user_id               (user_id)
#  index_players_on_user_id_and_game_id   (user_id,game_id) UNIQUE
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Player, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
