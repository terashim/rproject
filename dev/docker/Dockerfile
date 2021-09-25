FROM rocker/rstudio:4.1.0

ENV RENV_VERSION 0.14.0

# 各種 apt パッケージと日本語フォント（IPAexフォント）をインストール
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libxt-dev \
    libxml2-dev \
    libgit2-dev \
    fonts-ipaexfont \
  && apt-get clean

# remotes と renv をインストール
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_version('renv', version = '${RENV_VERSION}')"

# renv のパッケージキャッシュおよびライブラリルート用フォルダを作成
# SSH の known_hosts に github.com を追加
RUN mkdir -p /home/rstudio/.local/share/renv/cache \
  && mkdir -p /home/rstudio/.ssh \
  && mkdir -p /home/rstudio/.renv/library \
  && ssh-keyscan -t rsa github.com > /home/rstudio/.ssh/known_hosts \
  && chown -R rstudio:rstudio /home/rstudio \
  && chmod 700 /home/rstudio/.ssh

# 設定ファイルをコピー
COPY --chown=rstudio:rstudio .Renviron /home/rstudio/.Renviron
COPY --chown=rstudio:rstudio .ssh/config /home/rstudio/.ssh/config

# 起動スクリプトをコピー
COPY startup.sh /startup

# 起動コマンドを変更
CMD [ "/startup" ]
