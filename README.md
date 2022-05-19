# Welcome to rails-api-docker
Rails7 + mysql の APIを構築

## 事前準備
```
# dockerコンテナのビルド
docker-compose build

# dockerコンテナ起動
docker-compose up

# mysqlにログインしてユーザーを作成
docker-compose exec subject_db bash
mysql -u root -pexample
create user 'dbuser'@'%' identified by 'dbpass';
grant all on *.* to 'dbuser'@'%';

# DBマイグレーション
docker-compose exec subject_web bash -l
cd /rails-app/subject_api
bundle install
bundle exec rails db:create
bundle exec rails db:migrate

# JWT用のキーを作成
mkdir auth && cd $_
openssl genrsa 2024 > service.key
## .gitignoreに以下を追加
/auth

# rails API起動
bundle exec rails s -b "0.0.0.0" -p 3000
```

# メモ書き
## Dockerコンテナのビルド

```
docker-compose build
```

## Dockerコンテナ起動

```
# rails + mysql 起動
docker-compose up
```

## データベースの設定

```
# mysqlにログイン
docker-compose exec subject_db bash
mysql -u root -pexample
# dbuserを作成
create user 'dbuser'@'%' identified by 'dbpass';
grant all on *.* to 'dbuser'@'%';
```

## 最初からアプリを作り直す
rails-appフォルダ内のファイルを全て削除してから以下のコマンドを実行

```
# railsコンテナログイン
docker-compose exec web bash -l

# バンドル初期設定
bundle init
# gem 'rails' のコメントを解除
vi Gemfile
# rails をインストール
bundle install --path vendor/bundle
gem install rails
# railsアプリの作成とgemインストール
bundle exec rails new subject_api --api --database=mysql
```

rails-app/config/database.ymlを修正

```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: dbuser
  password: dbpass
  host: subject_db
  port: 3307
```

```
# データベースを再作成
bundle exec rails db:migrate:reset
```

## rbenvのコマンド一覧

```
# rbenvのバージョンを表示
$ rbenv -v

# 現在使用中のRubyのバージョンを表示
$ rbenv version

# インストール済みのRubyのバージョンを全て表示
$ rbenv versions

# デフォルトで利用するバージョンを指定
$ rbenv global 3.0.0

# 個別のアプリで使用したいバージョンを指定
$ rbenv local 3.0.0

# インストール可能なRubyのバージョン一覧を表示
$ rbenv install -l

# 指定したRubyのバージョンをインストール
$ rbenv install 3.0.0
```

## rails API 起動

```
bundle exec rails s -b "0.0.0.0" -p 3000
```

## RSpecの初期化
```
bundle exec rails generate rspec:install
```

## コントローラ作成
```
bundle exec rails g controller sessions create
bundle exec rails g controller users create
bundle exec rails g controller trades create
```

## モデル作成
```
bundle exec rails g model user     email:string password_digest:string
bundle exec rails g model trade    seller_id:bigint item_name:string points:integer closed:boolean
bundle exec rails g model purchase trade_id:bigint seller_id:bigint buyer_id:bigint item_name:string points:integer
```

## JWT設定
```
mkdir auth && cd $_
openssl genrsa 2024 > service.key
```

.gitignoreに以下を追加
```
auth/
```

## curl
```
curl -i -X POST -H "Content-Type: application/json" -d '{"email":"example@example.com", "password":"example_user"}' localhost:3000/api/v1/sessions
```

## テスト実行
```
bundle exec rspec -f h -o results.html
```
