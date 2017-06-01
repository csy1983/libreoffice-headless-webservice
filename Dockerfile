FROM ubuntu:17.04
# Libreoffice 5.3.1.2
# node v7.10.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    dirmngr \
    libreoffice \
    libreoffice-writer \
    ure \
    libreoffice-java-common \
    libreoffice-core \
    libreoffice-common \
    fonts-opensymbol \
    hyphen-fr \
    hyphen-de \
    hyphen-en-us \
    hyphen-it \
    hyphen-ru \
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
    fonts-unfonts-core \
    locales \
 && rm -rf /var/lib/apt/lists/*

# RUN groupadd --gid 1000 node \
# && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
 && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 7.10.0

RUN buildDeps='xz-utils' \
     && set -x \
     && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
     && rm -rf /var/lib/apt/lists/* \
     && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
     && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
     && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
     && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
     && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
     && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
     && apt-get purge -y --auto-remove $buildDeps \
     && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV YARN_VERSION 0.24.4

RUN set -ex \
   && for key in \
     6A010C5166006599AA17F08146C2130DFD2497F5 \
   ; do \
     gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
     gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
     gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
   done \
   && curl -fSL -o yarn.js "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-legacy-$YARN_VERSION.js" \
   && curl -fSL -o yarn.js.asc "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-legacy-$YARN_VERSION.js.asc" \
   && gpg --batch --verify yarn.js.asc yarn.js \
   && rm yarn.js.asc \
   && mv yarn.js /usr/local/bin/yarn \
   && chmod +x /usr/local/bin/yarn

# Add user
# RUN adduser --home=/opt/libreoffice --disabled-password --gecos "" --shell=/bin/bash libreoffice

# UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# ENTRYPOINT ["/usr/bin/libreoffice", "--nologo", "--norestore", "--invisible", "--headless"]
CMD [ "node" ]