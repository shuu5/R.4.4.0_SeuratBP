#!/bin/bash

# スクリプトをroot権限で実行するためのチェック
if [ "$EUID" -ne 0 ]; then
    echo "このスクリプトはroot権限で実行する必要があります。sudoを使用してください。"
    exit 1
fi

# 既存のDocker関連パッケージを削除（存在する場合のみ）
if dpkg -l | grep -q -E 'docker|containerd'; then
    apt-get remove -y docker docker-engine docker.io containerd runc
fi

# パッケージリストを更新
apt-get update

# 必要なパッケージをインストール
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# DockerのGPGキーを保存するディレクトリを作成
mkdir -p /etc/apt/keyrings

# Dockerの公式GPGキーをダウンロードして保存
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Dockerのリポジトリを追加
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# パッケージリストを再度更新
apt-get update

# Dockerエンジンと関連パッケージをインストール
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Dockerのバージョンを表示
docker -v