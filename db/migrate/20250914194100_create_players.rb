class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :position, null: false, default: 0, comment: '座席位置（0:東, 1:南, 2:西, 3:北）'
      t.integer :wind, null: false, default: 0, comment: '自風（0:東, 1:南, 2:西, 3:北）'
      t.text :hand, comment: '手牌データ（JSON配列）'
      t.integer :score, default: 25000

      t.timestamps
    end

    # 1つのゲームで同じポジションに複数人座れない
    add_index :players, [:game_id, :position], unique: true
    # 1人のユーザーが同じゲームに複数回参加できない
    add_index :players, [:user_id, :game_id], unique: true

    add_check_constraint :players, 'position >= 0 AND position <= 3', name: 'valid_position'
    add_check_constraint :players, 'wind >= 0 AND wind <= 3', name: 'valid_wind'
  end
end
