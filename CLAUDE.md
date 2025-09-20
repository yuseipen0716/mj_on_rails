# 麻雀ゲームアプリケーション開発

## プロジェクト概要

**目的**: オンライン4人制麻雀ゲーム + コンピュータ対戦
**技術スタック**: Rails 8.0, Turbo/Hotwire, Solid Cache
**データベース**: SQLite
**フロントエンド**: ERB + Turbo/Hotwire (React不使用)

## 技術的な前提

### 開発者の技術背景
- 日本語でのコミュニケーションを希望

### Rails 8.0の活用
- **Solid Cache**: インメモリ状態管理（Redisの代替）
- **Turbo/Hotwire**: SPA風のUX
- **Stimulus**: 必要最小限のJavaScript
- **Service層**: app/services/ でビジネスロジック
- **Domain層**: app/lib/mahjong/ でドメインロジック

## 麻雀ルール仕様

### 基本ルール
- **人数**: 4人制
- **ゲーム形式**: 東風戦（1局のみ）
- **開始点数**: 25,000点
- **牌**: 136枚（各牌4枚×34種類）
- **手牌**: 各プレイヤー13枚（親は14枚でスタート）
- **王牌**: 14枚固定（通常は引けない）

### 牌の種類と表現
```ruby
# 数牌（108枚）
萬子: ["1m", "2m", "3m", "4m", "5m", "6m", "7m", "8m", "9m"] # 各4枚
筒子: ["1p", "2p", "3p", "4p", "5p", "6p", "7p", "8p", "9p"] # 各4枚
索子: ["1s", "2s", "3s", "4s", "5s", "6s", "7s", "8s", "9s"] # 各4枚

# 字牌（28枚）
風牌: ["1z", "2z", "3z", "4z"] # 東南西北、各4枚
三元牌: ["5z", "6z", "7z"] # 白發中、各4枚
```

### 上がり形
- **基本形**: 4面子1雀頭（14枚）
- **面子**: 順子（123など）、刻子（111など）
- **雀頭**: 同じ牌2枚
- **特殊形**: 七対子、国士無双（今回は実装対象外）

### ゲーム進行フロー
1. **配牌**: 各プレイヤーに13枚配布
2. **親のターン**: 14枚目をツモ→打牌
3. **順番制**: 東→南→西→北の順
4. **アクション**: ツモ→打牌、または鳴き（ポン・チー・カン）
5. **終了条件**: 誰かが上がり、または牌山が尽きる（流局）

## データベース設計

### 現在のスキーマ構造
db/schema.rbを参照してください。

## アーキテクチャ設計

### ディレクトリ構成案
```
app/
├── controllers/         # HTTP処理
├── models/             # ActiveRecord, データアクセス
├── views/              # ERB テンプレート
├── services/           # ビジネスロジック
│   └── game/
│       ├── persistence_manager.rb    # DB保存戦略
│       ├── session_manager.rb        # ゲームセッション管理
│       ├── action_executor.rb        # アクション実行
│       └── wall_initializer.rb       # 牌山初期化
├── lib/                # ドメインロジック
│   └── mahjong/
│       ├── tile/
│       │   ├── definitions.rb        # 牌の定義・定数
│       │   ├── generator.rb          # 牌山生成
│       │   └── validator.rb          # 牌の妥当性検証
│       ├── hand/
│       │   ├── analyzer.rb           # 手牌解析
│       │   └── completion_checker.rb # 上がり判定
│       └── scoring/
│           ├── yaku_detector.rb      # 役判定
│           └── point_calculator.rb   # 点数計算
└── javascript/
    └── controllers/    # Stimulus controllers
```

### 状態管理戦略
- **ゲーム中**: Solid Cache（Rails 8.0）でインメモリ管理
- **永続化タイミング**:
  - ゲーム開始時（配牌完了時）
  - 1順完了時（4人が1回ずつアクション）
  - 重要イベント時（リーチ、鳴き、上がりなど）
  - または、非同期で1アクションごと保存？
- **イベント記録**: 全アクションをGameEventテーブルに記録（リプレイ用）

## 開発フェーズ

### Phase 1: 牌システム（現在実装中）
- [x] データベーススキーマ設計
- [ ] 牌定義システム（`Mahjong::Tile::Definitions`）
- [ ] 牌山生成・分割ロジック（`Mahjong::Tile::Generator`）
- [ ] 牌バリデーション（`Mahjong::Tile::Validator`）
- [ ] 配牌システム（`Game::WallInitializer`）

### Phase 2: 基本ゲームフロー
- [ ] プレイヤーターン管理
- [ ] 手牌表示（ERB + Turbo）
- [ ] 打牌システム
- [ ] ゲーム状態の画面更新（Turbo Streams）

### Phase 3: 鳴きシステム
- [ ] ポン・チー・カン判定ロジック
- [ ] 鳴き後の手牌処理
- [ ] 鳴きUI（リアルタイム応答）

### Phase 4: 上がりシステム
- [ ] 上がり判定（`Mahjong::Hand::CompletionChecker`）
- [ ] 役判定（`Mahjong::Scoring::YakuDetector`）
- [ ] 点数計算（`Mahjong::Scoring::PointCalculator`）

### Phase 5: UI/UX改善
- [ ] ゲーム画面の改善
- [ ] リアルタイム性の向上
- [ ] レスポンシブ対応

## 実装上の重要な考慮事項

### パフォーマンス
- **リアルタイム性**: WebSocket（ActionCable）でリアルタイム更新
- **状態管理**: Solid Cacheで高速アクセス
- **DB書き込み**: バッチ処理で負荷軽減

### データ整合性
- **トランザクション**: 重要な操作は必ずトランザクション内で実行
- **バリデーション**: 牌の数、手牌の妥当性を厳密にチェック
- **イベント記録**: 全アクションを記録して後から検証可能に

### エラーハンドリング
- **不正操作**: 無効な打牌、順番違いなどの検出
- **通信エラー**: ネットワーク切断時の状態復旧
- **データ損失防止**: 定期的なバックアップ保存

## コーディング規約

### Ruby/Rails
- Rails標準規約に準拠
- クラス名: PascalCase
- メソッド名: snake_case
- 定数: SCREAMING_SNAKE_CASE

### JavaScript（Stimulus）
- Controllerクラス: kebab-case（例: `game-board-controller.js`）
- データ属性: `data-controller`, `data-action`, `data-target`

### テスト
- RSpec使用
- モデル、サービス、ライブラリの単体テスト
- 統合テスト（System Spec）でブラウザ操作確認

## Claude Code利用時の指針

### 効果的な質問の仕方
1. **段階的な実装**: 一度に大きな機能を求めず、小さな単位で依頼
2. **具体的な要求**: 「○○クラスの○○メソッドを実装してください」
3. **テスト込み**: 「テストも含めて実装してください」
4. **麻雀ルール明示**: 必要に応じてルールの詳細を説明

### 実装順序
1. ドメインロジック（app/lib）から実装
2. サービスクラス（app/services）でビジネスロジック
3. モデル（app/models）にシンプルなメソッド追加
4. コントローラー（app/controllers）でHTTP処理
5. ビュー（app/views）でUI実装

## 参考情報

### 麻雀ルール
- 基本的な麻雀ルールは一般的なものに準拠
- 複雑な役（大三元、四暗刻など）は後回し
- まずは基本的な1翻役から実装

### 技術的参考
- Rails Guides: https://guides.rubyonrails.org/
- Hotwire: https://hotwired.dev/
- Turbo: https://turbo.hotwired.dev/

---

## 現在の開発状況

**進行中**: Phase 1の牌システム実装
**次のタスク**: `Mahjong::Tile::Definitions`クラスの実装
**課題**: annotate_rbの日本語コメント対応（英語コメント使用で回避）

このガイドは開発進捗に応じて随時更新してください。
