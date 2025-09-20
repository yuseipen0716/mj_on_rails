module Mahjong
  module Tile
    class Generator
      WALL_SIZE = 122
      WANPAI_SIZE = 14
      TOTAL_TILES = WALL_SIZE + WANPAI_SIZE

      class << self
        def generate_wall_and_wanpai
          tiles = Definitions.generate_full_set.shuffle

          {
            wall: tiles.first(WALL_SIZE),
            wanpai: tiles.last(WANPAI_SIZE)
          }
        end

        def generate_wall
          generate_wall_and_wanpai[:wall]
        end

        def generate_wanpai
          generate_wall_and_wanpai[:wanpai]
        end

        def deal_initial_hands(wall)
          raise ArgumentError, 'Wall must contain at least 52 tiles for dealing' if wall.size < 52

          hands = Array.new(4) { [] }
          dealt_tiles = 0

          # 3回、各プレイヤーに4枚ずつ配る（東家→南家→西家→北家の順）
          3.times do
            4.times do |player|
              4.times do
                hands[player] << wall[dealt_tiles]
                dealt_tiles += 1
              end
            end
          end

          # 最後に各プレイヤーに1枚ずつ配る（東家→南家→西家→北家の順）
          4.times do |player|
            hands[player] << wall[dealt_tiles]
            dealt_tiles += 1
          end

          # 親（東家）が最後に1枚ツモ
          hands[0] << wall[dealt_tiles]
          dealt_tiles += 1

          {
            hands: hands,
            remaining_wall: wall[dealt_tiles..]
          }
        end

        def validate_wall_size(wall)
          return false unless wall.is_a?(Array)
          return false unless wall.size == WALL_SIZE

          tile_counts = wall.tally
          Definitions::ALL_TILES.all? do |tile|
            count = tile_counts[tile] || 0
            count <= Definitions::TILE_COUNTS
          end
        end

        def validate_wanpai_size(wanpai)
          return false unless wanpai.is_a?(Array)
          return false unless wanpai.size == WANPAI_SIZE

          wanpai.all? { |tile| Definitions.valid_tile?(tile) }
        end

        def validate_full_set(tiles)
          return false unless tiles.is_a?(Array)
          return false unless tiles.size == TOTAL_TILES

          tile_counts = tiles.tally
          tile_counts == expected_tile_counts
        end

        private

        def expected_tile_counts
          Definitions::ALL_TILES.to_h { |tile| [ tile, Definitions::TILE_COUNTS ] }
        end
      end
    end
  end
end
