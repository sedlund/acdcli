FROM alpine:3.3

MAINTAINER sedlund@github @sredlund

RUN apk update \
    && apk upgrade \
    && apk add python3 fuse elinks wget ca-certificates \
    && wget -O- https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip3 install acdcli \
    && rm -rf /root/.cache \
    && apk del wget ca-certificates \
    && rm /var/cache/apk/* \
    && export uid=1000 gid=1000 \
    && groupadd --gid ${gid} user \
    && useradd --uid ${uid} --gid ${gid} --create-home user

ENV LIBFUSE_PATH=/usr/lib/libfuse.so.2

USER user
