ARG BASE_IMAGE=fragsoc/steamcmd-wine-xvfb
FROM rustagainshell/rash:1.0.0 AS rash
FROM ${BASE_IMAGE} AS vanilla
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

USER root
WORKDIR /
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y lib32gcc1

ARG UID=999
ARG GID=999

ENV INSTALL_LOC="/ror2"
ENV HOME=${INSTALL_LOC}

RUN mkdir -p $INSTALL_LOC && \
    groupadd -g $GID ror2 && \
    useradd -m -s /bin/false -u $UID -g $GID ror2 && \
    # Setup directory structure and permissions
    mkdir -p $INSTALL_LOC && \
    chown -R ror2:ror2 $INSTALL_LOC

USER ror2

# Config setup
COPY --from=rash /bin/rash /usr/bin/rash
COPY server.cfg.j2 /server.cfg
COPY docker-entrypoint.rh /docker-entrypoint.rh

# Ports
ARG GAME_PORT=27015
ARG STEAM_PORT=27016
ENV GAME_PORT=${GAME_PORT}
ENV STEAM_PORT=${STEAM_PORT}
EXPOSE $GAME_PORT/udp $STEAM_PORT/udp

# Install the ror2 server
# (we do this late to take maximum advantage of caching)
ARG APPID=1180760
ARG STEAM_BETAS
ARG STEAM_EPOCH
RUN steamcmd \
        +force_install_dir $INSTALL_LOC \
        +login anonymous \
        +@sSteamCmdForcePlatformType windows \
        +app_update $APPID $STEAM_BETAS validate \
        +app_update 1007 validate \
        +quit

WORKDIR $INSTALL_LOC
ENTRYPOINT ["rash", "/docker-entrypoint.rh"]

# Temporary container to download mod files with curl and unzip them
FROM debian:stretch-slim AS curl

RUN apt-get update && \
    apt-get install -y unzip curl

ARG BEPINEX_VERSION=5.4.1801
ARG ENIGMATIC_THUNDER_VERSION=0.1.5
ARG R2API_VERSION=3.0.71

WORKDIR /tmp
RUN curl -L -o ./r2api.zip \
        https://thunderstore.io/package/download/tristanmcpherson/R2API/${R2API_VERSION}/ && \
    curl -L -o ./bepinexpack.zip \
        https://thunderstore.io/package/download/bbepis/BepInExPack/${BEPINEX_VERSION}/ && \
    curl -L -o ./enigmaticthunder.zip \
        https://thunderstore.io/package/download/EnigmaDev/EnigmaticThunder/${ENIGMATIC_THUNDER_VERSION}/
RUN mkdir -p bepinexpack r2api engimaticthunder && \
    unzip ./bepinexpack.zip -d bepinex && \
    unzip ./r2api.zip -d r2api && \
    unzip ./enigmaticthunder.zip -d enigmaticthunder

# Basic BepInEx installation, also sets up mods directory
FROM vanilla AS bepinex

ENV MODS_LOC="/plugins"
ENV MODS_CONFIG_LOC="/plugin_config"

USER root
RUN mkdir -p $MODS_LOC $MODS_CONFIG_LOC && \
    chown -R ror2:ror2 $MODS_LOC $MODS_CONFIG_LOC

USER ror2
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/BepInEx $INSTALL_LOC/BepInEx
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/doorstop_config.ini $INSTALL_LOC
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/winhttp.dll $INSTALL_LOC
RUN ln -s $MODS_LOC $INSTALL_LOC/BepInEx/plugins/rootmods
RUN ln -s $MODS_CONFIG_LOC $INSTALL_LOC/BepInEx/config

VOLUME $MODS_LOC
VOLUME $MODS_CONFIG_LOC

# R2API + BepInEx
FROM bepinex AS r2api

COPY --from=curl --chown=ror2 /tmp/r2api/plugins $INSTALL_LOC/BepInEx/plugins/
COPY --from=curl --chown=ror2 /tmp/r2api/monomod $INSTALL_LOC/BepInEx/monomod/

# EnigmaticThunder + BepInEx
FROM bepinex AS enigmaticthunder

COPY --from=curl --chown=ror2 /tmp/enigmaticthunder/plugins $INSTALL_LOC/BepInEx/plugins
