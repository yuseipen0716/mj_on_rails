require 'rails_helper'

RSpec.describe Mahjong::Tile::Generator do
  describe '定数' do
    it '正しい山のサイズを定義している' do
      expect(described_class::WALL_SIZE).to eq(122)
    end

    it '正しい王牌のサイズを定義している' do
      expect(described_class::WANPAI_SIZE).to eq(14)
    end

    it '総牌数が山+王牌と等しい' do
      expect(described_class::TOTAL_TILES).to eq(136)
      expect(described_class::WALL_SIZE + described_class::WANPAI_SIZE).to eq(136)
    end
  end

  describe '.generate_wall_and_wanpai' do
    subject(:result) { described_class.generate_wall_and_wanpai }

    it 'wallとwanpaiキーを持つハッシュを返す' do
      expect(result).to have_key(:wall)
      expect(result).to have_key(:wanpai)
    end

    it '正しいサイズの山を生成する' do
      expect(result[:wall].size).to eq(described_class::WALL_SIZE)
    end

    it '正しいサイズの王牌を生成する' do
      expect(result[:wanpai].size).to eq(described_class::WANPAI_SIZE)
    end

    it '完全な牌セットを含む' do
      all_generated_tiles = result[:wall] + result[:wanpai]
      expect(all_generated_tiles.sort).to eq(Mahjong::Tile::Definitions.generate_full_set.sort)
    end

    it '複数回呼び出すと異なる順序で生成される' do
      result1 = described_class.generate_wall_and_wanpai
      result2 = described_class.generate_wall_and_wanpai

      expect(result1[:wall]).not_to eq(result2[:wall])
    end

    it '山のすべての牌が有効' do
      result[:wall].each do |tile|
        expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
      end
    end

    it '王牌のすべての牌が有効' do
      result[:wanpai].each do |tile|
        expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
      end
    end
  end

  describe '.generate_wall' do
    subject(:wall) { described_class.generate_wall }

    it '正しいサイズの配列を返す' do
      expect(wall.size).to eq(described_class::WALL_SIZE)
    end

    it '有効な牌のみを含む' do
      wall.each do |tile|
        expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
      end
    end
  end

  describe '.generate_wanpai' do
    subject(:wanpai) { described_class.generate_wanpai }

    it '正しいサイズの配列を返す' do
      expect(wanpai.size).to eq(described_class::WANPAI_SIZE)
    end

    it '有効な牌のみを含む' do
      wanpai.each do |tile|
        expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
      end
    end
  end

  describe '.deal_initial_hands' do
    let(:wall) { described_class.generate_wall }
    subject(:result) { described_class.deal_initial_hands(wall) }

    context '十分な山のサイズがある場合' do
      it 'handsとremaining_wallキーを持つハッシュを返す' do
        expect(result).to have_key(:hands)
        expect(result).to have_key(:remaining_wall)
      end

      it '南家、西家、北家に13枚ずつ配る' do
        expect(result[:hands][1].size).to eq(13)
        expect(result[:hands][2].size).to eq(13)
        expect(result[:hands][3].size).to eq(13)
      end

      it '親（東家）に14枚配る' do
        expect(result[:hands][0].size).to eq(14)
      end

      it '合計53枚配る' do
        total_dealt = result[:hands].sum(&:size)
        expect(total_dealt).to eq(53)
      end

      it '残りの山が正しいサイズ' do
        expect(result[:remaining_wall].size).to eq(wall.size - 53)
      end

      it '手牌と残りの山で牌の重複がない' do
        all_dealt_tiles = result[:hands].flatten + result[:remaining_wall]
        expect(all_dealt_tiles.size).to eq(wall.size)
        expect(all_dealt_tiles.sort).to eq(wall.sort)
      end

      it '配られた牌がすべて有効' do
        result[:hands].flatten.each do |tile|
          expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
        end
      end

      it '正しい配牌順序（東→南→西→北の順で配られている）' do
        # 特定の山で配牌順序をテスト
        test_wall = (0...122).map { |i| "tile_#{i}" }
        test_result = described_class.deal_initial_hands(test_wall)

        # 最初の4枚（1回目の4枚配り）
        expect(test_result[:hands][0][0]).to eq("tile_0")   # 東家1枚目
        expect(test_result[:hands][1][0]).to eq("tile_4")   # 南家1枚目
        expect(test_result[:hands][2][0]).to eq("tile_8")   # 西家1枚目
        expect(test_result[:hands][3][0]).to eq("tile_12")  # 北家1枚目

        # 最後の1枚配り（49-52枚目）
        expect(test_result[:hands][0][12]).to eq("tile_48") # 東家最後の1枚（13枚目）
        expect(test_result[:hands][1][12]).to eq("tile_49") # 南家最後の1枚（13枚目）
        expect(test_result[:hands][2][12]).to eq("tile_50") # 西家最後の1枚（13枚目）
        expect(test_result[:hands][3][12]).to eq("tile_51") # 北家最後の1枚（13枚目）

        # 親の最後のツモ（53枚目）
        expect(test_result[:hands][0][13]).to eq("tile_52") # 東家のツモ（14枚目）
      end
    end

    context '山のサイズが不十分な場合' do
      let(:small_wall) { Array.new(51, '1m') }

      it 'ArgumentErrorが発生する' do
        expect { described_class.deal_initial_hands(small_wall) }.to raise_error(ArgumentError, /Wall must contain at least 52 tiles/)
      end
    end
  end

  describe '.validate_wall_size' do
    context '有効な山の場合' do
      let(:valid_wall) { described_class.generate_wall }

      it '正しいサイズの配列でtrueを返す' do
        expect(described_class.validate_wall_size(valid_wall)).to be true
      end
    end

    context '無効な入力の場合' do
      it '配列でない場合はfalseを返す' do
        expect(described_class.validate_wall_size('not an array')).to be false
      end

      it 'サイズが間違っている場合はfalseを返す' do
        wrong_size_wall = Array.new(100, '1m')
        expect(described_class.validate_wall_size(wrong_size_wall)).to be false
      end

      it '同じ牌が多すぎる場合はfalseを返す' do
        invalid_wall = Array.new(described_class::WALL_SIZE, '1m')
        expect(described_class.validate_wall_size(invalid_wall)).to be false
      end
    end
  end

  describe '.validate_wanpai_size' do
    context '有効な王牌の場合' do
      let(:valid_wanpai) { described_class.generate_wanpai }

      it '正しいサイズで有効な牌の場合trueを返す' do
        expect(described_class.validate_wanpai_size(valid_wanpai)).to be true
      end
    end

    context '無効な入力の場合' do
      it '配列でない場合はfalseを返す' do
        expect(described_class.validate_wanpai_size('not an array')).to be false
      end

      it 'サイズが間違っている場合はfalseを返す' do
        wrong_size_wanpai = Array.new(10, '1m')
        expect(described_class.validate_wanpai_size(wrong_size_wanpai)).to be false
      end

      it '無効な牌が含まれる場合はfalseを返す' do
        invalid_wanpai = Array.new(described_class::WANPAI_SIZE, 'invalid')
        expect(described_class.validate_wanpai_size(invalid_wanpai)).to be false
      end
    end
  end

  describe '.validate_full_set' do
    context '有効な完全セットの場合' do
      let(:valid_set) { Mahjong::Tile::Definitions.generate_full_set }

      it '正しい完全セットでtrueを返す' do
        expect(described_class.validate_full_set(valid_set)).to be true
      end
    end

    context '無効な入力の場合' do
      it '配列でない場合はfalseを返す' do
        expect(described_class.validate_full_set('not an array')).to be false
      end

      it 'サイズが間違っている場合はfalseを返す' do
        wrong_size_set = Array.new(100, '1m')
        expect(described_class.validate_full_set(wrong_size_set)).to be false
      end

      it '牌の枚数が間違っている場合はfalseを返す' do
        invalid_set = Array.new(136, '1m')
        expect(described_class.validate_full_set(invalid_set)).to be false
      end
    end
  end

  describe 'Definitionsとの統合' do
    it '生成された牌がすべてDefinitionsに従って有効' do
      result = described_class.generate_wall_and_wanpai
      all_tiles = result[:wall] + result[:wanpai]

      all_tiles.each do |tile|
        expect(Mahjong::Tile::Definitions.valid_tile?(tile)).to be true
      end
    end

    it '適切な牌の分布を維持する' do
      result = described_class.generate_wall_and_wanpai
      all_tiles = result[:wall] + result[:wanpai]
      tile_counts = all_tiles.tally

      Mahjong::Tile::Definitions::ALL_TILES.each do |tile|
        expect(tile_counts[tile]).to eq(4), "Expected 4 of #{tile}, got #{tile_counts[tile] || 0}"
      end
    end
  end
end
