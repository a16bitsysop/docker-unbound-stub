FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

EXPOSE 53

RUN apk add --no-cache unbound openssl

WORKDIR /etc/unbound
COPY etc/ ./

WORKDIR /usr/local/bin
COPY entrypoint.sh ./

ENTRYPOINT ["entrypoint.sh"]
