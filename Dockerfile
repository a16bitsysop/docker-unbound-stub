FROM alpine:3.14
LABEL maintainer="Duncan Bellamy <dunk@denkimushi.com>"

# hadolint ignore=DL3018
RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
&& apk add --no-cache --upgrade unbound openssl drill tzdata \
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

#HEALTHCHECK CMD unbound-control status || exit 1
