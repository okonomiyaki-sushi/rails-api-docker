FROM ubuntu:20.04

# apt install時に対話で設定値を選択することができないので、以下の環境変数を変更して対応
ENV DEBIAN_FRONTEND noninteractive

# mirrorの向き先をjpに変更
RUN sed -i.org -e "s/\/\/archive\.ubuntu\.com/\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list

# パッケージ一覧を更新
RUN apt update
# パッケージを更新
RUN apt -y upgrade

SHELL ["/bin/bash", "-c"]

# vimインストール
RUN apt install -y vim
# pingインストール
RUN apt install -y iputils-ping \
                   net-tools

# 必要なパッケージをインストール
RUN apt install -y git \
                   make \
                   curl \
                   wget \
                   libmysqlclient-dev

# ruby-build推奨ライブラリインストール
# https://github.com/rbenv/ruby-build/wiki
RUN apt install -y autoconf \
                   bison \
                   build-essential \
                   libssl-dev \
                   libyaml-dev \
                   libreadline6-dev \
                   zlib1g-dev \
                   libncurses5-dev \
                   libffi-dev \
                   libgdbm6 \
                   libgdbm-dev \
                   libdb-dev

# rbenvインストール
RUN apt install -y rbenv
# ruby-buildダウンロード
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# 全ユーザにパスを通す設定
RUN touch /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh

# ruby3.0.2インストール
RUN rbenv install -v 3.0.2
RUN rbenv local 3.0.2
RUN rbenv global 3.0.2

# nodejs インストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs

# yarn インストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

# 環境変数を元に戻しておく
ENV DEBIAN_FRONTEND dialog

WORKDIR /rails-app

# コンテナ起動時(docker run)に実行するシェルスクリプト
ENTRYPOINT ["/bin/bash", "-c", "-l"]