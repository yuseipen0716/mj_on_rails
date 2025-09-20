class HomesController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    # トップページ用のデータがあれば取得（一旦まだ何も表示しない）
    # @total_games = Game.count
    # @online_users = User.where('updated_at > ?', 5.minutes.ago).count
  end

  def show
    # ログイン後の画面（ようこそ）
  end
end
