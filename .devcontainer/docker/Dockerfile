ARG R_VERSION="4.2.0"
FROM rocker/rstudio:${R_VERSION}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libxt-dev \
    libxml2-dev \
    libgit2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# renv をインストール
ARG RENV_VERSION="0.15.4"
COPY install-renv.R /install-renv.R
RUN Rscript /install-renv.R $RENV_VERSION \
  && su -c 'mkdir -p /home/rstudio/{.local/share/renv/cache,.renv/library}' rstudio
COPY --chown=rstudio:rstudio .Renviron /home/rstudio/.Renviron

# 追加的な apt パッケージをインストール（例: IPA日本語フォント）
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    fonts-ipaexfont \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
