class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :title, null: false, limit: 100
      t.integer :status, null: false, default: 0
      t.integer :turn, default: 0
      t.integer :current_player, default: 0, comment: '現在の手番プレイヤー（0:東, 1:南, 2:西, 3:北）'
      t.text :wall, comment: '牌山データ（JSON配列）'

      t.timestamps
    end

    # ゲーム状態での検索用
    add_index :games, :status
    add_index :games, :created_at
  end
end
