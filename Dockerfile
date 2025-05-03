FROM ich777/debian-baseimage:bullseye_amd64

LABEL org.opencontainers.image.source="https://github.com/Salain810/docker-steamcmd-server"

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 lib32z1 curl build-essential pkg-config libssl-dev protobuf-compiler && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
	export PATH="/root/.cargo/bin:${PATH}"

# Copy steamguard-cli source
COPY steamguard-cli /tmp/steamguard-cli

# Build and install steamguard-cli
RUN cd /tmp/steamguard-cli && \
	export PATH="/root/.cargo/bin:${PATH}" && \
	cargo build --release && \
	cp target/release/steamguard /usr/local/bin/ && \
	cd / && \
	rm -rf /tmp/steamguard-cli && \
	rustup self uninstall -y && \
	apt-get remove -y build-essential pkg-config libssl-dev protobuf-compiler && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* /root/.cargo

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
