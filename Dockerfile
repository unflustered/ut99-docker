FROM i386/ubuntu:18.04 AS tmp
COPY ./ut ./umodasu ./bonus_content ./server ./
RUN apt-get update && apt-get install -y perl-modules && \
    tar xzf ut-server-436.tar.gz && \
    tar xzf UTPG-451-patch.tar.gz -C ut-server Web System Help

# install bonus pack content
RUN mv CTF-HallOfGiants.unr CTF-Orbital.unr ut-server/Maps/ && \
    perl umod.pl -b ut-server -i UTBonusPack.umod && \
    perl umod.pl -b ut-server -i DE.umod && \
    perl umod.pl -b ut-server -i UTInoxxPack.umod && \
    perl umod.pl -b ut-server -i UTBonusPack4.umod

# tidy permissions
RUN chown -R root:root ut-server && \
    chmod +x server

FROM i386/ubuntu:18.04
LABEL maintainer="unflustered@l.u.awful.name"
EXPOSE 7777-7778/udp 8777/udp 7770/tcp
ENV STARTUP_MAP="DM-Turbine" \
    GAME_MODE="Botpack.DeathMatchPlus" \
    MUTATORS="" \
    SERVER_NAME="Another UT Server" \
    SERVER_SHORT_NAME="UT Server" \
    ADMIN_NAME="" \
    ADMIN_EMAIL="" \
    REGION="7" \
    MOTD_LINE1="" \
    FASTDL_URL="" \
    FASTDL_USE_COMPRESSION="True" \
    NET_MAX_CLIENT_RATE="5000" \
    NET_INITIAL_CONNECT_TIMEOUT="30.0" \
    MAX_PLAYERS="8" \
    MIN_PLAYERS="0" \
    MAX_SPECTATORS="2" \
    # LEAVE_CONFIG=<anything> will cause the server startup script to skip config modification
    LEAVE_CONFIG="" \
    GAME_PASSWORD="" \
    ADMIN_PASSWORD="" \
    WEB_ADMIN_USER="" \
    WEB_ADMIN_PASSWORD="" \
    ADVERTISE_SERVER="True"
# ucc wants some X libs even though this is a headless dedicated server? hmm, okay.
RUN apt-get update && apt-get install -y libxext6 libx11-6 && rm -fr /var/lib/apt/lists
COPY --from=tmp ut-server/ /ut-server/
COPY --from=tmp server /server
VOLUME /ut-server
CMD [ "/server" ]
