require 'rails_helper'

RSpec.describe Mahjong::Tile::Definitions do
  describe '定数の定義' do
    it '全ての牌種類が正しく定義されている' do
      expect(described_class::MANZU).to eq(%w[1m 2m 3m 4m 5m 6m 7m 8m 9m])
      expect(described_class::PINZU).to eq(%w[1p 2p 3p 4p 5p 6p 7p 8p 9p])
      expect(described_class::SOUZU).to eq(%w[1s 2s 3s 4s 5s 6s 7s 8s 9s])
      expect(described_class::KAZEHAI).to eq(%w[1z 2z 3z 4z])
      expect(described_class::SANGENPAI).to eq(%w[5z 6z 7z])
    end

    it '牌のコレクションが正しく定義されている' do
      expect(described_class::SUUPAI.size).to eq(27)
      expect(described_class::JIHAI.size).to eq(7)
      expect(described_class::ALL_TILES.size).to eq(34)
      expect(described_class::TOTAL_TILES).to eq(136)
    end
  end

  describe '.suupai?' do
    context '数牌の場合' do
      it 'returns true' do
        expect(described_class.suupai?('1m')).to be true
        expect(described_class.suupai?('5p')).to be true
        expect(described_class.suupai?('9s')).to be true
      end
    end

    context '字牌の場合' do
      it 'returns false' do
        expect(described_class.suupai?('1z')).to be false
        expect(described_class.suupai?('5z')).to be false
      end
    end
  end

  describe '.jihai?' do
    context '字牌の場合' do
      it 'returns true' do
        expect(described_class.jihai?('1z')).to be true
        expect(described_class.jihai?('5z')).to be true
        expect(described_class.jihai?('7z')).to be true
      end
    end

    context '数牌の場合' do
      it 'returns false' do
        expect(described_class.jihai?('1m')).to be false
        expect(described_class.jihai?('5p')).to be false
      end
    end
  end

  describe '.kazehai?' do
    context '風牌の場合' do
      it 'returns true' do
        expect(described_class.kazehai?('1z')).to be true
        expect(described_class.kazehai?('4z')).to be true
      end
    end

    context '風牌以外の場合' do
      it 'returns false' do
        expect(described_class.kazehai?('5z')).to be false
        expect(described_class.kazehai?('1m')).to be false
      end
    end
  end

  describe '.sangenpai?' do
    context '三元牌の場合' do
      it 'returns true' do
        expect(described_class.sangenpai?('5z')).to be true
        expect(described_class.sangenpai?('7z')).to be true
      end
    end

    context '三元牌以外の場合' do
      it 'returns false' do
        expect(described_class.sangenpai?('1z')).to be false
        expect(described_class.sangenpai?('1m')).to be false
      end
    end
  end

  describe '.valid_tile?' do
    context '有効な牌の場合' do
      it 'returns true' do
        expect(described_class.valid_tile?('1m')).to be true
        expect(described_class.valid_tile?('9s')).to be true
        expect(described_class.valid_tile?('7z')).to be true
      end
    end

    context '無効な牌の場合' do
      it 'returns false' do
        expect(described_class.valid_tile?('0m')).to be false
        expect(described_class.valid_tile?('10p')).to be false
        expect(described_class.valid_tile?('8z')).to be false
        expect(described_class.valid_tile?('invalid')).to be false
      end
    end
  end

  describe '.tile_type' do
    context '有効な牌の場合' do
      it '正しい牌種を返す' do
        expect(described_class.tile_type('1m')).to eq(:manzu)
        expect(described_class.tile_type('5p')).to eq(:pinzu)
        expect(described_class.tile_type('9s')).to eq(:souzu)
        expect(described_class.tile_type('1z')).to eq(:kazehai)
        expect(described_class.tile_type('5z')).to eq(:sangenpai)
      end
    end

    context '無効な牌の場合' do
      it 'returns nil' do
        expect(described_class.tile_type('invalid')).to be_nil
      end
    end
  end

  describe '.tile_number' do
    context '有効な牌の場合' do
      it '正しい数字を返す' do
        expect(described_class.tile_number('1m')).to eq(1)
        expect(described_class.tile_number('5p')).to eq(5)
        expect(described_class.tile_number('9s')).to eq(9)
        expect(described_class.tile_number('2z')).to eq(2)
      end
    end

    context '無効な牌の場合' do
      it 'returns nil' do
        expect(described_class.tile_number('invalid')).to be_nil
      end
    end
  end

  describe '.tile_name' do
    context '数牌の場合' do
      it '正しい名前を返す' do
        expect(described_class.tile_name('1m')).to eq('1萬')
        expect(described_class.tile_name('5p')).to eq('5筒')
        expect(described_class.tile_name('9s')).to eq('9索')
      end
    end

    context '風牌の場合' do
      it '正しい名前を返す' do
        expect(described_class.tile_name('1z')).to eq('東')
        expect(described_class.tile_name('2z')).to eq('南')
        expect(described_class.tile_name('3z')).to eq('西')
        expect(described_class.tile_name('4z')).to eq('北')
      end
    end

    context '三元牌の場合' do
      it '正しい名前を返す' do
        expect(described_class.tile_name('5z')).to eq('白')
        expect(described_class.tile_name('6z')).to eq('發')
        expect(described_class.tile_name('7z')).to eq('中')
      end
    end

    context '無効な牌の場合' do
      it 'returns nil' do
        expect(described_class.tile_name('invalid')).to be_nil
      end
    end
  end

  describe '.same_suit?' do
    context '同じ種類の牌の場合' do
      it 'returns true' do
        expect(described_class.same_suit?('1m', '5m')).to be true
        expect(described_class.same_suit?('2p', '8p')).to be true
        expect(described_class.same_suit?('3s', '7s')).to be true
        expect(described_class.same_suit?('1z', '4z')).to be true
        expect(described_class.same_suit?('5z', '7z')).to be true
      end
    end

    context '異なる種類の牌の場合' do
      it 'returns false' do
        expect(described_class.same_suit?('1m', '1p')).to be false
        expect(described_class.same_suit?('5p', '5s')).to be false
        expect(described_class.same_suit?('1z', '5z')).to be false
      end
    end

    context '無効な牌が含まれる場合' do
      it 'returns false' do
        expect(described_class.same_suit?('1m', 'invalid')).to be false
        expect(described_class.same_suit?('invalid', '1m')).to be false
      end
    end
  end

  describe '.consecutive?' do
    context '連続する数牌の場合' do
      it 'returns true' do
        expect(described_class.consecutive?('1m', '2m', '3m')).to be true
        expect(described_class.consecutive?('3m', '1m', '2m')).to be true
        expect(described_class.consecutive?('7p', '8p', '9p')).to be true
      end
    end

    context '連続しない牌の場合' do
      it 'returns false' do
        expect(described_class.consecutive?('1m', '3m', '5m')).to be false
        expect(described_class.consecutive?('1m', '2m', '4m')).to be false
      end
    end

    context '異なる種類の牌の場合' do
      it 'returns false' do
        expect(described_class.consecutive?('1m', '2p', '3s')).to be false
      end
    end

    context '字牌の場合' do
      it 'returns false' do
        expect(described_class.consecutive?('1z', '2z', '3z')).to be false
      end
    end
  end

  describe '.generate_full_set' do
    it '正しい牌数を生成する' do
      full_set = described_class.generate_full_set
      expect(full_set.size).to eq(136)
    end

    it '各牌種が4枚ずつ含まれている' do
      full_set = described_class.generate_full_set
      described_class::ALL_TILES.each do |tile|
        expect(full_set.count(tile)).to eq(4)
      end
    end
  end
end
