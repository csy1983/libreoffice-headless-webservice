FROM ubuntu:17.04

RUN apt-get update

# Build essential
RUN apt-get install -y \
      build-essential \
      python \
      git \
      locales

# Node.js v8.x
COPY setup_nodejs_8.x /tmp/setup
RUN cat /tmp/setup | bash -

# Libreoffice v5.3.1.2
RUN apt-get install -y --no-install-recommends \
      openjdk-8-jre-headless \
      libreoffice \
      libreoffice-writer \
      libreoffice-java-common \
      libreoffice-core \
      libreoffice-common \
      ure \
      unoconv \
      hyphen-fr \
      hyphen-de \
      hyphen-en-us \
      hyphen-it \
      hyphen-ru \
      fonts-opensymbol \
      fonts-dejavu \
      fonts-dejavu-core \
      fonts-dejavu-extra \
      fonts-dustin \
      fonts-f500 \
      fonts-fanwood \
      fonts-freefont-ttf \
      fonts-liberation \
      fonts-lmodern \
      fonts-lyx \
      fonts-sil-gentium \
      fonts-texgyre \
      fonts-tlwg-purisa \
      fonts-arphic-ukai \
      fonts-arphic-uming \
      fonts-ipafont-mincho \
      fonts-ipafont-gothic \
      fonts-unfonts-core

# Add user
# RUN adduser --home=/opt/libreoffice --disabled-password --gecos "" --shell=/bin/bash libreoffice

# UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
