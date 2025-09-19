# Dockerfile（開発用シンプル版）
FROM ruby:3.3.0

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs npm sqlite3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Gemfile をコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのコードをコピー
COPY . .

# ポート3000を公開
EXPOSE 3000

# Rails サーバーを起動
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
