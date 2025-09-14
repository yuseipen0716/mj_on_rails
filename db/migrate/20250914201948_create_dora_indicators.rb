class CreateDoraIndicators < ActiveRecord::Migration[8.0]
  def change
    create_table :dora_indicators do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true, comment: 'カンを行ったプレイヤー（初期ドラの場合はnull）'
      t.string :tile, null: false, limit: 10, comment: 'ドラ表示牌（例: "3m", "west", "white"）'
      t.integer :position, null: false, comment: 'ドラの位置（0:最初のドラ, 1:1つ目のカンドラ, 2:2つ目のカンドラ, 3:3つ目のカンドラ）'
      t.integer :source, null: false, default: 0, comment: 'ドラの出現元（例: 0:initial, 1:minkan, 2:ankan, 3:kakan）'
      t.integer :turn_number, null: false, default: 0, comment: 'このドラが出現した巡数'
      t.integer :action_sequence, null: false, default: 0, comment: '同一巡内でのアクション順序番号'

      t.timestamps
    end

    add_index :dora_indicators, [:game_id, :position], unique: true, comment: '1つのゲームで同じ位置のドラは1つのみ'
    add_index :dora_indicators, [:game_id, :turn_number], comment: 'ゲーム内での巡数検索用'
    add_index :dora_indicators, :source, comment: 'ドラの出現元での検索用'
    add_index :dora_indicators, [:game_id, :created_at], comment: 'ゲーム内でのドラ出現順序検索用'
  end
end
