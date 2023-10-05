FROM rocker/rstudio:4.3.1

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

# Download renv 1.0.3 tarball
ARG RENV_BOOTSTRAP_TARBALL=/opt/renv_1.0.3.tar.gz
RUN wget -O $RENV_BOOTSTRAP_TARBALL \
  'https://packagemanager.posit.co/cran/__linux__/jammy/2023-10-04/src/contrib/renv_1.0.3.tar.gz?r_version=4.3&arch=x86_64' \
  && chown rstudio:rstudio $RENV_BOOTSTRAP_TARBALL \
  && rm -rf /home/rstudio/.config/rstudio \
  && su -c 'mkdir -p /home/rstudio/{.cache/R/renv/library,.config,.local/share}' rstudio
