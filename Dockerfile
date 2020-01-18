FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN apk add --no-cache unbound py-unbound openssl
COPY entrypoint.sh /usr/local/bin/
COPY etc/ /etc/unbound/
ENTRYPOINT ["entrypoint.sh"]
