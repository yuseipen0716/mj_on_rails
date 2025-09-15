class SessionsController < ApplicationController
  def new
    # ログイン/サインアップ画面
  end

  def create
    if params[:action_type] == 'signup'
      # 新規ID生成
      begin
        @user = User.create!(name: params[:name])
        session[:user_id] = @user.id
        redirect_to play_path, notice: "ID「#{@user.unique_id}」を生成しました！次回はこのIDでログインしてください。"
      rescue ActiveRecord::RecordInvalid => e
        redirect_to login_path, alert: "ユーザー作成に失敗しました: #{e.message}"
      end
    else
      # 既存IDでログイン
      @user = User.find_by(unique_id: params[:unique_id])
      if @user
        session[:user_id] = @user.id
        redirect_to play_path, notice: 'ログインしました'
      else
        redirect_to login_path, alert: 'IDが見つかりません'
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
