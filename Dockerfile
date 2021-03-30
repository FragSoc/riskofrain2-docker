FROM rustagainshell/rash AS rash
FROM steamcmd/steamcmd
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ARG APPID=1180760
ARG STEAM_BETAS
ARG UID=999
ARG GID=999
ARG GAME_PORT=27015
ARG STEAM_PORT=27016

ENV INSTALL_LOC="/ror2"
ENV HOME=${INSTALL_LOC}
ENV GAME_PORT=27015
ENV STEAM_PORT=27016

USER root
WORKDIR /
RUN apt-get update && \
    apt-get install -y wine-stable xvfb lib32gcc1 && \
    mkdir -p $INSTALL_LOC && \
    groupadd -g $GID ror2 && \
    useradd -m -s /bin/false -u $UID -g $GID ror2 && \
    # Setup directory structure and permissions
    mkdir -p $INSTALL_LOC && \
    chown -R ror2:ror2 $INSTALL_LOC

USER ror2

# Install the ror2 server
RUN steamcmd \
        +login anonymous \
        +force_install_dir $INSTALL_LOC \
        +@sSteamCmdForcePlatformType windows \
        +app_update $APPID $STEAM_BETAS validate \
        +quit

# Config setup
COPY --from=rash /bin/rash /usr/bin/rash
COPY server.cfg.j2 /server.cfg
COPY docker-entrypoint.rh /docker-entrypoint.rh

# I/O
EXPOSE $GAME_PORT/udp $STEAM_PORT/udp
WORKDIR $INSTALL_LOC
ENTRYPOINT ["rash", "/docker-entrypoint.rh"]
