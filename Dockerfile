FROM alpine:3.12

LABEL maintainer "Irraz <irraz@r2brain.com>"

ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_DATA_HOME="/config" \
XDG_CONFIG_HOME="/config"
ENV TZ America/Los_Angeles

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories
RUN apk update
#RUN apk --no-cache add bash tzdata tor=0.4.3.5-r0
RUN apk --no-cache add bash tzdata tor=0.4.4.6-r0

EXPOSE 9001 9030

# TOR configuration through environment variables.
ENV RELAY_TYPE relay
ENV TOR_ORPort 9001
ENV TOR_DirPort 9030
ENV TOR_DataDirectory /data
ENV TOR_ContactInfo "irraz irraz@r2brain.com"
ENV TOR_RelayBandwidthRate "100 KBytes"
ENV TOR_RelayBandwidthBurst "200 KBytes"

# Copy the default configurations.
COPY torrc.bridge.default /config/torrc.bridge.default
COPY torrc.relay.default /config/torrc.relay.default
COPY torrc.exit.default /config/torrc.exit.default

COPY entrypoint.sh /entrypoint.sh
RUN chmod ugo+rx /entrypoint.sh

COPY /root /
VOLUME /data
