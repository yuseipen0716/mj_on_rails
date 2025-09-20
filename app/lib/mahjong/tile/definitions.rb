module Mahjong
  module Tile
    class Definitions
      MANZU = %w[1m 2m 3m 4m 5m 6m 7m 8m 9m].freeze
      PINZU = %w[1p 2p 3p 4p 5p 6p 7p 8p 9p].freeze
      SOUZU = %w[1s 2s 3s 4s 5s 6s 7s 8s 9s].freeze

      KAZEHAI = %w[1z 2z 3z 4z].freeze
      SANGENPAI = %w[5z 6z 7z].freeze

      SUUPAI = (MANZU + PINZU + SOUZU).freeze
      JIHAI = (KAZEHAI + SANGENPAI).freeze
      ALL_TILES = (SUUPAI + JIHAI).freeze

      TILE_COUNTS = 4
      TOTAL_TILES = ALL_TILES.size * TILE_COUNTS

      KAZEHAI_NAMES = {
        '1z' => '東',
        '2z' => '南',
        '3z' => '西',
        '4z' => '北'
      }.freeze

      SANGENPAI_NAMES = {
        '5z' => '白',
        '6z' => '發',
        '7z' => '中'
      }.freeze

      class << self
        def suupai?(tile)
          SUUPAI.include?(tile)
        end

        def jihai?(tile)
          JIHAI.include?(tile)
        end

        def kazehai?(tile)
          KAZEHAI.include?(tile)
        end

        def sangenpai?(tile)
          SANGENPAI.include?(tile)
        end

        def valid_tile?(tile)
          ALL_TILES.include?(tile)
        end

        def tile_type(tile)
          return nil unless valid_tile?(tile)

          case tile[-1]
          when 'm' then :manzu
          when 'p' then :pinzu
          when 's' then :souzu
          when 'z'
            if kazehai?(tile)
              :kazehai
            elsif sangenpai?(tile)
              :sangenpai
            end
          end
        end

        def tile_number(tile)
          return nil unless valid_tile?(tile)
          tile[0].to_i
        end

        def tile_name(tile)
          return nil unless valid_tile?(tile)

          if jihai?(tile)
            KAZEHAI_NAMES[tile] || SANGENPAI_NAMES[tile]
          else
            "#{tile_number(tile)}#{tile_type_name(tile)}"
          end
        end

        def same_suit?(tile1, tile2)
          return false unless valid_tile?(tile1) && valid_tile?(tile2)
          tile_type(tile1) == tile_type(tile2)
        end

        def consecutive?(tile1, tile2, tile3)
          return false unless [ tile1, tile2, tile3 ].all? { |t| suupai?(t) && same_suit?(tile1, t) }

          numbers = [ tile1, tile2, tile3 ].map { |t| tile_number(t) }.sort
          numbers == [ numbers[0], numbers[0] + 1, numbers[0] + 2 ]
        end

        def generate_full_set
          ALL_TILES.flat_map { |tile| [ tile ] * TILE_COUNTS }
        end

        private

        def tile_type_name(tile)
          case tile_type(tile)
          when :manzu then '萬'
          when :pinzu then '筒'
          when :souzu then '索'
          else ''
          end
        end
      end
    end
  end
end
