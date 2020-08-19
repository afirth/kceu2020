FROM alpine:3

ARG VER=3.5.0
ENV VVER=v${VER}

RUN apk update \
  && apk add --no-cache \
    ca-certificates \
    make \
    bash \
    tree \
  && wget -O sops https://github.com/mozilla/sops/releases/download/$VVER/sops-$VVER.linux \
  && chmod +x sops \
  && mv sops /usr/bin/sops

COPY Makefile /builder/Makefile

WORKDIR /workspace

ENTRYPOINT ["/usr/bin/make", "-f", "/builder/Makefile"]
CMD ["usage"]
