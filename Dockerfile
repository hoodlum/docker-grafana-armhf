FROM hypriot/rpi-alpine as build-stage

MAINTAINER Soeren Stelzer

ENV VERSION 4.4.3

ENV GRAFANA_FILE grafana-${VERSION}.linux-armhf.tar.gz
ENV GRAFANA_URL https://github.com/fg2it/grafana-on-raspberry/releases/download/v${VERSION}/${GRAFANA_FILE}

RUN set -xe \
    && apk add --no-cache --virtual .build-deps ca-certificates curl tar \
    && update-ca-certificates \
    && mkdir -p /usr/src \
    && curl -sSL ${GRAFANA_URL} | tar xz --strip 1 -C /usr/src \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

FROM hypriot/rpi-alpine

COPY --from=build-stage /usr/src/bin /
COPY --from=build-stage /usr/src/conf /etc/grafana
COPY entrypoint.sh /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["telegraf"]

