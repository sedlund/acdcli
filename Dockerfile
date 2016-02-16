FROM alpine:3.3

MAINTAINER sredlund@github

RUN apk update \
    && apk upgrade \
    && apk add python3 fuse elinks wget ca-certificates \
    && wget -O- https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip3 install acdcli \
    && rm -rf /root/.cache \
    && apk del wget ca-certificates \
    && rm /var/cache/apk/* 

ENV LIBFUSE_PATH=/usr/lib/libfuse.so.2
