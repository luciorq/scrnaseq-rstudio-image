FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt update -y -qq \
  && DEBIAN_FRONTEND=noninteractive apt upgrade -y -qq \
  && DEBIAN_FRONTEND=noninteractive apt install -y -qq \
    sudo \
    vim \
    wget \
    whois \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    curl \
    pandoc \
    make \
    zlib1g-dev \
    libhdf5-dev \
    git \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgmp3-dev \
    libglpk-dev \
    libgsl0-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    gdebi-core \
    systemd \
    htop \
    tar \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    ca-certificates;

ARG R_VERSION=4.4.1
ARG RIG_VERSION=0.7.0

RUN mkdir -p /opt/install_apps/rig \
  && mkdir -p /opt/install_apps/rstudio \
  && curl -f -s -S -L --create-dirs --insecure --silent -o /opt/install_apps/rig/rig.tar.gz -C - https://github.com/r-lib/rig/releases/download/v${RIG_VERSION}/rig-linux-${RIG_VERSION}.tar.gz \
  && tar -C /opt/install_apps/rig/ -xzf /opt/install_apps/rig/rig.tar.gz \
  && ln -sf /opt/install_apps/rig/bin/rig /usr/local/bin/rig \
  && rig install "${R_VERSION}";

# RUN R -q -e 'install.packages(c("tidyverse", "BiocManager", "Seurat"), repos="https://packagemanager.posit.co/cran/__linux__/noble/latest")';

RUN R -q -e "pak::pkg_install(pkg = c( \
  'tidyverse', 'BiocManager', 'pak', 'reticulate', \
  'styler', 'lintr', 'rstudioapi', 'quarto', 'rmarkdown', 'knitr', \
  'bioc::DESeq2', 'bioc::SingleCellExperiment', \
  'Seurat@4.4.0', 'SeuratObject@4.1.4' \
  ),lib = '/opt/R/${R_VERSION}/lib/R/library')";


RUN curl -f -s -S -L --create-dirs --insecure --silent -o /opt/install_apps/rstudio/rstudio-server.deb -C - https://rstudio.org/download/latest/stable/server/jammy/rstudio-server-latest-amd64.deb \
  && gdebi -n /opt/install_apps/rstudio/rstudio-server.deb \
  && rm /opt/install_apps/rstudio/rstudio-server.deb \
  && rm /opt/install_apps/rig/rig.tar.gz \
  && (echo 'www-port=8989' >> /etc/rstudio/rserver.conf);

EXPOSE 8989

RUN mkdir -p /opt/bin; echo -ne '#!/bin/bash\nUSER=rstudio /usr/lib/rstudio-server/bin/rserver --server-daemonize=0 --auth-none=0 --www-port=8989;\n' > /opt/bin/entrypoint.sh; chmod +x /opt/bin/entrypoint.sh;

CMD ["/opt/bin/entrypoint.sh"]
