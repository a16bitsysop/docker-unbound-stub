FROM alpine:3.12
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

# hadolint ignore=DL3018
RUN apk add --no-cache unbound openssl drill tzdata \
&& mkdir -p /var/lib/unbound && chown unbound:unbound /var/lib/unbound

WORKDIR /etc/unbound/unbound.conf.d
WORKDIR /etc/unbound/local.conf.d

WORKDIR /etc/unbound
COPY conf/unbound.conf .

WORKDIR /usr/local/bin
COPY travis-helpers/set-timezone.sh entrypoint.sh ./

CMD [ "entrypoint.sh" ]
VOLUME /etc/unbound/local.conf.d
EXPOSE 53/tcp 53/udp

HEALTHCHECK CMD unbound-control status || exit 1 
