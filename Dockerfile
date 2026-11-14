FROM ich777/debian-baseimage:bullseye_amd64

LABEL org.opencontainers.image.source="https://github.com/Salain810/docker-steamcmd-server"

# steamguard-cli: official prebuilt static binary, pinned by version and SHA-256
ARG STEAMGUARD_VERSION=0.18.4
ARG STEAMGUARD_SHA256=36286b1ee2de797ec59e545f482a39b105cc53c93019bbec8efe552d7eaebe14

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 lib32z1 curl ca-certificates && \
	curl -fsSL -o /usr/local/bin/steamguard \
		"https://github.com/dyc3/steamguard-cli/releases/download/v${STEAMGUARD_VERSION}/steamguard-linux-musl-x86_64" && \
	echo "${STEAMGUARD_SHA256}  /usr/local/bin/steamguard" | sha256sum -c - && \
	chmod 755 /usr/local/bin/steamguard && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV VALIDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770
ENV STEAM_SHARED_SECRET=""
ENV STEAM_IDENTITY_SECRET=""

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
