# R.4.4.0_SeuratBP

## 概要
このリポジトリは、R.4.4.0, Seurat, BPCells, tidyverse環境をDockerコンテナでセットアップするためのものです。

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
6. コマンドパレットを開く (Ctrl + Shift + P)。
7. 「Remote-Containers: Open Folder in Container」を選択する。
8. projectsフォルダの任意のプロジェクトフォルダに移動する。
    ```bash
    cd projects/任意のプロジェクトフォルダ/
    ```
9. Rを起動する。
    ```bash
    R
    ```
10. R内で依存関係をインストールする。
    ```R
    renv::restore()
    ```
11. (RStudio-serverを使用する場合は、[http://localhost:8787](http://localhost:8787)にアクセスする。)


## 新しいRパッケージのインストール

- renv::install()を使います。
- githubから直接ダウンロードするなど特殊なインストール方法の場合、library("パッケージ名")をどこかのRファイルに記載してからrenv::snapshot()を実行して依存関係を記録してください。

## 新しいlinuxパッケージのインストール

- 新しいパッケージをインストールしたい場合は、`Dockerfile`の`RUN apt-get update && apt-get install -y \`に追記する必要があります。
- コンテナ内でインストールしても、コンテナを一旦閉じると元に戻ることがあります。
