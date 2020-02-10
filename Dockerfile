FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN apk add --no-cache unbound openssl

WORKDIR /etc/unbound
COPY conf/ ./

WORKDIR /usr/local/bin
COPY entrypoint.sh ./

VOLUME [ "/etc/unbound/local.conf.d" "/etc/unbound/unbound.conf.d" ]

ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 53/tcp 53/udp
