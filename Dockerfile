# Set the base image to use for subsequent instructions
FROM alpine:3.21

# make config output directory
RUN mkdir -p /app

# pia scripts get confused if config file isn't here
WORKDIR /app

# Add required packages
RUN \
  apk add --no-cache \
  jq \
  curl \
  wireguard-tools \
  iproute2 \
  git

# clone upstream repo
RUN git clone https://github.com/triffid/pia-wg.git

WORKDIR /app/pia-wg

COPY wrapper.sh .
COPY pia-wg.sh .

# Configure the container to be run as an executable
ENTRYPOINT ["/app/pia-wg/wrapper.sh"]

# Labels
LABEL \
  org.opencontainers.image.created=$CREATED \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$GITHUB_SHA \
  org.opencontainers.image.url="https://github.com/craquehouse/k8s-gluetun-pia-init" \
  org.opencontainers.image.documentation="https://github.com/craquehouse/k8s-gluetun-pia-init" \
  org.opencontainers.image.source="https://github.com/craquehouse/k8s-gluetun-pia-init/USAGE.md" \
  org.opencontainers.image.title="PIA wg0.conf generation tool" \
  org.opencontainers.image.description="Uses https://github.com/triffid/pia-wg to generate a wg0.conf for use by gluetun"

