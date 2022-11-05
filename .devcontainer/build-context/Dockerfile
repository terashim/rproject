ARG R_VERSION="4.2.1"
FROM rocker/rstudio:${R_VERSION}

# Install required APT packages
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
  && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
  --mount=type=cache,target=/var/lib/apt/lists \
  --mount=type=cache,target=/var/cache/apt/archives \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libxt-dev \
    libxml2-dev \
    libgit2-dev

# Install renv 0.16.0 from RSPM snapshot
RUN R -e 'install.packages("renv",repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2022-10-14/")' \
  && rm -rf /home/rstudio/.config/rstudio \
  && su -c 'mkdir -p /home/rstudio/{.local/share/renv/cache,.renv/library,.config}' rstudio
COPY Rprofile.site $R_HOME/etc/Rprofile.site
COPY --chown=rstudio:rstudio .Renviron /home/rstudio/.Renviron
