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

# Install renv
ARG RENV_VERSION="0.16.0"
COPY install-renv.R /install-renv.R
RUN Rscript /install-renv.R $RENV_VERSION \
  && su -c 'mkdir -p /home/rstudio/{.local/share/renv/cache,.renv/library}' rstudio

# Configuration files
RUN echo 'options("renv.config.autoloader.enabled" = FALSE); \
  if (file.exists(renv::paths$library()) || file.exists(renv::paths$lockfile())) \
  { renv::load(); renv::restore(prompt = FALSE) }' \
  >> ${R_HOME}/etc/Rprofile.site
COPY --chown=rstudio:rstudio .Renviron /home/rstudio/.Renviron
