class GamesController < ApplicationController
  before_action :require_login, only: [ :index, :show, :create ]

  def index
    # ゲーム一覧・マッチング画面
  end

  def show
    # ゲーム画面
  end

  def create
    # 新しいゲームを作成
  end
end
