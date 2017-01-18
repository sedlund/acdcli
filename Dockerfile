FROM alpine:3.5

MAINTAINER sedlund@github @sredlund

RUN apk add --no-cache python3 fuse elinks ca-certificates \
    && pip3 install acdcli \
    && addgroup user \
    && adduser -G user -D user

ENV LIBFUSE_PATH=/usr/lib/libfuse.so.2

USER user

ENTRYPOINT ["/usr/bin/acdcli"]

CMD ["-h"]
