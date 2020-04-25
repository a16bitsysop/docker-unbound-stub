FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN apk add --no-cache unbound openssl drill

WORKDIR /etc/unbound/unbound.conf.d
WORKDIR /etc/unbound/local.conf.d

WORKDIR /etc/unbound
COPY conf/unbound.conf .

WORKDIR /usr/local/bin
COPY entrypoint.sh ./

VOLUME "/etc/unbound/local.conf.d"

CMD [ "entrypoint.sh" ]

EXPOSE 53/tcp 53/udp
