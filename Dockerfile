FROM i386/ubuntu:18.04 AS tmp
RUN apt-get update && apt-get install -y perl-modules && rm -fr /var/lib/apt/lists
# Latest v469b patch to be installed over the old v436 server
ADD https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v469b/OldUnreal-UTPatch469b-Linux.tar.bz2 ./
COPY ./ut ./umodasu ./bonus_content ./server ./
RUN tar xzf ut-server-436.tar.gz --exclude=ut-server/Logs && \
    tar xjf OldUnreal-UTPatch469b-Linux.tar.bz2 -C ut-server && \
    chown -R root:root ut-server

# install bonus pack content
RUN perl umod.pl -b ut-server -i UTBonusPack.umod && \
    perl umod.pl -b ut-server -i DE.umod && \
    perl umod.pl -b ut-server -i UTInoxxPack.umod && \
    perl umod.pl -b ut-server -i UTBonusPack4.umod && \
    mv CTF-HallOfGiants.unr CTF-Orbital.unr ut-server/Maps/

# adjust defaults
RUN chmod +x server && \
    ./server ini_set ut-server/System/UnrealTournament.ini IpDrv.TcpNetDriver MaxClientRate 5000 && \
    ./server ini_set ut-server/System/UnrealTournament.ini IpDrv.TcpNetDriver InitialConnectTimeout 30.0 && \
    ./server ini_set ut-server/System/UnrealTournament.ini IpServer.UdpServerUplink DoUplink True && \
    ./server ini_set ut-server/System/UnrealTournament.ini UWeb.WebServer bEnabled True && \
    ./server ini_set ut-server/System/UnrealTournament.ini UWeb.WebServer ListenPort 7770

FROM i386/ubuntu:18.04
LABEL maintainer="unflustered@l.u.awful.name"
EXPOSE 7777-7781/udp 8777/udp 7770/tcp
ENV STARTUP_MAP="DM-Turbine" \
    GAME_MODE="Botpack.DeathMatchPlus" \
    MUTATORS=""
COPY --from=tmp ut-server/ /ut-server/
COPY --from=tmp ut-server/System/UnrealTournament.ini /.loki/ut/System/
COPY --from=tmp server /server
VOLUME /.loki/ut
CMD [ "/server" ]
