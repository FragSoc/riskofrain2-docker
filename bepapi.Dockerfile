FROM debian:stretch-slim AS curl
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

RUN apt-get update && \
    apt-get install -y unzip curl

ARG BEPINEX_VERSION=5.3.1
ARG R2API_VERSION=2.5.14

WORKDIR /tmp
RUN curl -L -o ./r2api.zip \
        https://thunderstore.io/package/download/tristanmcpherson/R2API/${R2API_VERSION}/ && \
    curl -L -o ./bepinexpack.zip \
        https://thunderstore.io/package/download/bbepis/BepInExPack/${BEPINEX_VERSION}/
RUN mkdir -p bepinexpack r2api && \
    unzip ./bepinexpack.zip -d bepinex && \
    unzip ./r2api.zip -d r2api

FROM fragsoc/riskofrain2:vanilla

ENV MODS_LOC="/plugins"

USER root
RUN mkdir -p $MODS_LOC && \
    chown -R ror2:ror2 $MODS_LOC

USER ror2
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/BepInEx $INSTALL_LOC/BepInEx
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/doorstop_config.ini $INSTALL_LOC
COPY --from=curl --chown=ror2 /tmp/bepinex/BepInExPack/winhttp.dll $INSTALL_LOC
RUN rm -r $INSTALL_LOC/BepInEx/plugins && \
    ln -s $MODS_LOC $INSTALL_LOC/BepInEx/plugins

COPY --from=curl --chown=ror2 /tmp/r2api/plugins $MODS_LOC/
COPY --from=curl --chown=ror2 /tmp/r2api/monomod $INSTALL_LOC/BepInEx/monomod/

VOLUME $MODS_LOC
