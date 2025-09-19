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
FactoryBot.define do
  factory :game do
    sequence(:title) { |n| "三麻ゲーム ##{n}" }
    status { :waiting }
    turn { 0 }
    current_player { 0 }
    wall { generate_mahjong_wall }

    trait :waiting do
      status { :waiting }
      turn { 0 }
      current_player { 0 }
    end

    trait :playing do
      status { :playing }
      turn { 5 }
      current_player { 1 }
    end

    trait :finished do
      status { :finished }
      turn { 20 }
      current_player { 3 }
    end

    factory :waiting_game, traits: [ :waiting ]
    factory :playing_game, traits: [ :playing ]
    factory :finished_game, traits: [ :finished ]
  end

  def generate_mahjong_wall
    tiles = []
    # 数牌 (1-9 x 4枚ずつ)
    %w[p s m].each do |suit|
      (1..9).each do |num|
        4.times { tiles << "#{num}#{suit}" }
      end
    end
    # 字牌 (4枚ずつ)
    %w[east south west north white green red].each do |honor|
      4.times { tiles << honor }
    end
    tiles.shuffle
  end
end
