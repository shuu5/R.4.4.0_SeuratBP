### 始めにこのコマンドでrenv.lockに記載されているパッケージをすべてインストール
renv::restore()      


### パッケージ一覧(追加したパッケージはここに追記しておくと便利)
library(languageserver)  # R言語のための言語サーバープロトコルを提供

library(BiocManager)     # Bioconductorパッケージの管理とインストールを支援
library(remotes)         # GitHubなどのリモートリポジトリからRパッケージをインストール

library(Seurat)          # シングルセルRNAシーケンスデータの解析ツール
library(tidyverse)       # データ操作と可視化のためのパッケージコレクション

library(BPCells)         # 大規模なシングルセルデータの効率的な処理
library(presto)          # シングルセルRNAシーケンスデータの高速な差次的発現解析
library(glmGamPoi)       # シングルセルRNAシーケンスデータのための一般化線形モデル

library(Signac)          # シングルセルATACシーケンスデータの解析ツール
library(SeuratData)      # Seuratオブジェクトのデータセット
library(Azimuth)         # シングルセルRNAシーケンスデータの参照マッピング
library(SeuratWrappers)  # Seuratのための追加機能とラッパー関数

library(IRkernel)    # Jupyter NotebookでRを使用するためのカーネル
library(knitr)       # R Markdownドキュメントの動的レポート生成を支援
library(rmarkdown)   # R Markdownドキュメントの作成とレンダリングを支援


### 新しいパッケージをインストールしたらこのコマンドでrenv.lockを更新
renv::snapshot()