FROM python:3.6-slim-buster

# TERM needs to be set here for scrapinghub exec environments
# PIP_TIMEOUT so installation doesn't hang forever
ENV TERM=xterm \
    PIP_TIMEOUT=180 \
    SHUB_ENFORCE_PIP_CHECK=1

RUN apt-get update -qq
RUN apt-get install -qy \
    netbase ca-certificates apt-transport-https \
    build-essential locales \
    default-libmysqlclient-dev \
    imagemagick \
    libbz2-dev \
    libdb-dev \
    libevent-dev \
    libffi-dev \
    libjpeg-dev \
    liblzma-dev \
    libpcre3-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libz-dev \
    unixodbc unixodbc-dev \
    telnet vim htop iputils-ping curl wget lsof git sudo \
    ghostscript

# space optimization to remove apt cache
RUN rm -rf /var/lib/apt/lists

# ad custom locales to provide backward support with scrapy cloud 1.0
COPY locales /etc/locale.gen
RUN locale-gen

# requirements for scrapy stack as deployed on Scrapinghub
COPY requirements.txt /stack-requirements.txt
RUN pip install --no-cache-dir -r stack-requirements.txt

# scrapinghub builtin addons
RUN mkdir /app
COPY addons_eggs /app/addons_eggs
RUN chown nobody:nogroup -R /app/addons_eggs
