FROM steamcmd/steamcmd AS steambuild
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ARG APPID=1180760
ARG STEAM_BETAS
ARG UID=999
ARG GID=999

ENV CONFIG_LOC="/config"
ENV INSTALL_LOC="/ror2"
ENV HOME=${INSTALL_LOC}

USER root
WORKDIR /
RUN apt-get update && \
    apt-get install -y wine-stable xvfb lib32gcc1 && \
    mkdir -p $INSTALL_LOC && \
    groupadd -g $GID ror2 && \
    useradd -m -s /bin/false -u $UID -g $GID ror2 && \
    # Setup directory structure and permissions
    mkdir -p $CONFIG_LOC $INSTALL_LOC && \
    chown -R ror2:ror2 $INSTALL_LOC $CONFIG_LOC

USER ror2

# Install the ror2 server
RUN steamcmd \
        +login anonymous \
        +force_install_dir $INSTALL_LOC \
        +@sSteamCmdForcePlatformType windows \
        +app_update $APPID $STEAM_BETAS validate \
        +quit && \
    ln -s $CONFIG_LOC/server.cfg "${INSTALL_LOC}/Risk of Rain 2_Data/Config/server.cfg"
COPY --chown=ror2 server.cfg $CONFIG_LOC/server.cfg

# I/O
VOLUME $CONFIG_LOC
EXPOSE 27015/udp 27016/udp
WORKDIR $INSTALL_LOC
ENTRYPOINT ["xvfb-run", "wine", "./Risk of Rain 2.exe"]
