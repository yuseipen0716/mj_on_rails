class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true, comment: 'アクションを実行したプレイヤー'
      t.integer :event_type, null: false, comment: 'イベントタイプ（0:draw_tile, 1:discard_tile, 2:pon, 3:chi, 4:kan, 5:ron, 6:tsumo, 7:riichi等）'
      t.text :data, comment: 'イベントの詳細データ（JSON形式）'
      t.integer :turn_number, null: false, default: 0, comment: '発生した巡数'
      t.integer :action_sequence, null: false, default: 0, comment: '同一巡内でのアクション順序'

      t.timestamps
    end

    # インデックス
    add_index :game_events, [ :game_id, :created_at ]
    add_index :game_events, :event_type
    add_index :game_events, [ :game_id, :event_type ]
    add_index :game_events, [ :player_id, :event_type ]
    add_index :game_events, [ :game_id, :turn_number ]
  end
end
