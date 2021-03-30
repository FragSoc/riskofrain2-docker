FROM debian:stretch-slim AS curl

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

COPY --from=curl /tmp/bepinex/BepInExPack/BepInEx $INSTALL_LOC/BepInEx
COPY --from=curl /tmp/bepinex/BepInExPack/doorstop_config.ini $INSTALL_LOC
COPY --from=curl /tmp/bepinex/BepInExPack/winhttp.dll $INSTALL_LOC

COPY --from=curl /tmp/r2api/plugins $INSTALL_LOC/BepInEx/plugins/
COPY --from=curl /tmp/r2api/monomod $INSTALL_LOC/BepInEx/monomod/
