# R.4.4.0_SeuratBP

## 概要
このリポジトリは、R.4.4.0, Seurat, BPCells, tidyverse環境をDockerコンテナでセットアップするためのものです。

## 準備
1. GitHubのアカウントを作成する。
2. GitHub Personal Access Tokenを作成する。
    - [GitHubの設定](https://github.com/settings/tokens)から「Generate new token(classic)」をクリック
    - 「repo」の権限をチェックして「Generate」をクリック
    - 表示されたトークンをコピーして保存する
3. Cursorをインストールする。
    - [Cursorの公式サイト](https://cursor.sh/)からインストーラーをダウンロードしてインストール


## セットアップ手順

1. リポジトリをローカルにクローンする:
    ```bash
    git clone https://github.com/shuu5/R.4.4.0_SeuratBP.git
    ```
2. VSCodeでクローンしたフォルダを開く。
    ```bash
    cursor R.4.4.0_SeuratBP/
    ```
3. Dockerの自動セットアップを行う(docker_init.sh を実行する。)
    ```bash
    sudo docker_init.sh
    ```
4. 拡張機能「Dev Containers」「Remote Explorer」「Docker」をインストールする。
5. containerフォルダを開く。
    ```bash
    cursor container/
    ```
6. 使用するdockerイメージをダウンロードする
    ```bash
    docker pull shuu5/seuratbp-container:latest
    ```
7. .env.exampleのGITHUB_PATに先ほど取得したGithub Personal Access Tokenを設定する。
8. .env.exampleを.envという名前に変更する。
9. コマンドパレットを開く (Ctrl + Shift + P)。
10. 「Remote-Containers: Open Folder in Container」を選択する。
11. projectsフォルダの任意のプロジェクトフォルダ(まずはsample_projectを試すと良い)に移動する。
    ```bash
    cd projects/sample_project/
    ```
12. Rを起動する。
    ```bash
    R
    ```
13. R内で依存関係をインストールする。(初回はかなり時間がかかる)
    ```R
    renv::restore()
    ```
14. (RStudio-serverを使用する場合は、[http://localhost:8787](http://localhost:8787)にアクセスする。)

## 新しいプロジェクトを立ち上げる場合

1. コマンドパレットを開いて(Ctrl + Shift + P)「Tasks: Run Task」を実行
2. 「Create New Project」を実行
3. projectsフォルダに「new_project」というフォルダが作成される。
4. new_projectフォルダに移動する。
    ```bash
    cd projects/new_project/
    ```
5. Rを起動する。
    ```bash
    R
    ```
6. 依存関係をインストールする。
    ```R
    renv::restore()
    ```
7. フォルダ名を好きなプロジェクト名に変更する。（変更しないと次のnew_projectを作成できない）

## 新しいRパッケージのインストール

1. renv::install()を使う。
    ```R
    renv::install("パッケージ名")
    ```
2. src/libraries.Rに追記する。
    ```R
    library(パッケージ名)
    ```
3. 依存関係をrenv.lockに反映させる。
    ```R
    renv::snapshot()
    ```