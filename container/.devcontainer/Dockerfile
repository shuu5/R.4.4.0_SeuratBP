FROM rocker/rstudio:4.4.0

# 必要なlinux パッケージをインストール(インストールするRパッケージごとに修正が必要)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libxt-dev \
    fonts-ipaexfont \
    libhdf5-dev \
    libglpk-dev \
    patch \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    libfftw3-dev \
  && apt-get clean

# Python 3.11のシンボリックリンクを作成
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN update-alternatives --set python3 /usr/bin/python3.11

# pythonコマンドのシンボリックリンクを作成
RUN ln -s /usr/bin/python3.11 /usr/bin/python

# leidenalgとnumpyをpipでインストール
RUN python3.11 -m pip install leidenalg numpy

# Python 3.11をreticulateに設定
ENV RETICULATE_PYTHON=/usr/bin/python3.11

# RStudio の Global Options 設定
COPY --chown=rstudio:rstudio \
  .devcontainer/.config/rstudio/rstudio-prefs.json \
  /home/rstudio/.config/rstudio/rstudio-prefs.json

# renv のパッケージキャッシュを作成
RUN mkdir -p /home/rstudio/.local/share/renv/cache \
  && chown -R rstudio:rstudio /home/rstudio

# renv, languageserver, jsonlite, remotesをインストール
RUN R -e "install.packages('jsonlite', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"

# remotesを使って、githubからのパッケージインストール(BPCells)
RUN R -e "remotes::install_github('bnprks/BPCells/r')"
