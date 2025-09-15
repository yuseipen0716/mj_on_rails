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
FactoryBot.define do
  factory :player do
    association :user
    association :game
    position { :east }
    wind { :east }
    hand { generate_player_hand }
    score { 25000 }

    trait :east_player do
      position { :east }
      wind { :east }
    end

    trait :south_player do
      position { :south }
      wind { :south }
    end

    trait :west_player do
      position { :west }
      wind { :west }
    end

    trait :north_player do
      position { :north }
      wind { :north }
    end

    factory :east_player, traits: [ :east_player ]
    factory :south_player, traits: [ :south_player ]
    factory :west_player, traits: [ :west_player ]
    factory :north_player, traits: [ :north_player ]
  end

  def generate_player_hand
    tiles = %w[1m 2m 3m 4m 5m 6m 7m 8m 9m 1p 2p 3p 4p]
    tiles.sample(13)
  end
end
