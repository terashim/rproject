FROM rocker/rstudio:4.0.3

# 各種 apt ライブラリと日本語フォント（IPAexフォント）をインストール
# renv のパッケージキャッシュを作成
# SSH の known_hosts に github.com を追加
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libxt-dev \
    libxml2-dev \
    libgit2-dev \
    fonts-ipaexfont \
  && apt-get clean \
  && mkdir -p /home/rstudio/.local/share/renv/cache \
  && mkdir -p /home/rstudio/.ssh \
  && ssh-keyscan -t rsa github.com > /home/rstudio/.ssh/known_hosts \
  && chown -R rstudio:rstudio /home/rstudio \
  && chmod 700 /home/rstudio/.ssh

# SSH Config をコピー
COPY --chown=rstudio:rstudio .ssh/config /home/rstudio/.ssh/config

# 起動スクリプトをコピー
COPY startup.sh /startup

# 起動コマンドを変更
CMD [ "/startup" ]
