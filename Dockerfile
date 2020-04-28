FROM i386/ubuntu:18.04 AS tmp
COPY ./ut ./umodasu ./bonus_content ./
RUN tar xzf ut-server-436.tar.gz && \
    tar xzf UTPG-451-patch.tar.gz -C ut-server Web System Help

# install bonus pack content
RUN apt-get update && apt-get install -y perl-modules && rm -fr /var/lib/apt/lists && \
    perl umod.pl -b ut-server -i UTBonusPack.umod && \
    perl umod.pl -b ut-server -i DE.umod && \
    perl umod.pl -b ut-server -i UTInoxxPack.umod && \
    perl umod.pl -b ut-server -i UTBonusPack4.umod && \
    mv CTF-HallOfGiants.unr CTF-Orbital.unr ut-server/Maps/

# tidy permissions
RUN chown -R root:root ut-server

COPY ./server ./
# adjust some defaults
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
# ucc wants some X libs even though this is a headless dedicated server? hmm, okay.
RUN apt-get update && apt-get install -y libxext6 libx11-6 && rm -fr /var/lib/apt/lists
COPY --from=tmp ut-server/ /ut-server/
COPY --from=tmp ut-server/System/UnrealTournament.ini /.loki/ut/System/
COPY --from=tmp server /server
RUN adduser --system --no-create-home ut && chown -R ut:nogroup /.loki/ut
USER ut
VOLUME /.loki/ut
CMD [ "/server" ]
