ARG INSTALL_EXTRAS=irc,XMPP,telegram,slack

FROM python:3.9 AS build
ARG INSTALL_EXTRAS

WORKDIR /wheel

COPY . .
RUN pip wheel --wheel-dir=/wheel wheel . .[${INSTALL_EXTRAS}]

FROM python:3.9-slim as base
ARG INSTALL_EXTRAS

COPY --from=build /wheel /wheel

RUN apt update && \
    apt install -y git && \
    cd /wheel && \
    pip3 -vv install --no-cache-dir --no-index --find-links /wheel \
    errbot-hl errbot-hl[${INSTALL_EXTRAS}] && \
    rm -rf /wheel /var/lib/apt/lists/*

RUN useradd -m errbot

FROM base
EXPOSE 3141 3142
VOLUME /home/errbot
WORKDIR /home/errbot

USER errbot
WORKDIR /home/errbot

RUN errbot --init

EXPOSE 3141 3142
VOLUME /home/errbot
STOPSIGNAL SIGINT

ENTRYPOINT [ "/usr/local/bin/errbot" ]
