FROM alpine:3.6
MAINTAINER Sven Gottwald <svengo@gmx.net>

ENV VERSION 3.0.13.8
ENV ARCH amd64

ADD https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
ADD https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk /tmp/
ADD http://dl.4players.de/ts/releases/${VERSION}/teamspeak3-server_linux_${ARCH}-${VERSION}.tar.bz2 /tmp/teamspeak.tar.bz2

WORKDIR /tmp/
RUN apk add --update --no-cache bzip2 su-exec bash && \
  apk add /tmp/glibc-2.25-r0.apk && \
  tar jxf /tmp/teamspeak.tar.bz2 && \
  mv /tmp/teamspeak3-server_linux_${ARCH} /teamspeak && \
  rm -rf /tmp/* && \
  apk del bzip2

WORKDIR /

RUN addgroup -S teamspeak && \
  adduser -h /teamspeak -G teamspeak -S -D teamspeak && \
  chown -R teamspeak:teamspeak /teamspeak

VOLUME ["/data"]

COPY docker-entry-point.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9987/udp 10011 30033
CMD ["ts3server"]
