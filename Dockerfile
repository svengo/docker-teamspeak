FROM alpine:3.6
MAINTAINER Sven Gottwald <svengo@gmx.net>

ENV USER teamspeak
ENV GROUP teamspeak
ENV TS_DIRECTORY=/teamspeak

RUN apk add --no-cache wget bzip2 w3m su-exec tini ca-certificates bash \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub\
  && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk \
  && apk add glibc-2.25-r0.apk \
  && TS_SERVER_VER="$(w3m -dump https://www.teamspeak.com/downloads | grep -m 1 'Server 64-bit ' | awk '{print $NF}')" \
  && wget --quiet http://dl.4players.de/ts/releases/${TS_SERVER_VER}/teamspeak3-server_linux_amd64-${TS_SERVER_VER}.tar.bz2 -O /tmp/teamspeak.tar.bz2 \
  && tar jxf /tmp/teamspeak.tar.bz2 -C / \
  && mv /teamspeak3-server_* ${TS_DIRECTORY} \
  && rm /tmp/teamspeak.tar.bz2

RUN addgroup -S ${GROUP} \
  && adduser -h ${TS_DIRECTORY} -G ${GROUP} -S -D ${USER} \
  && chown -R ${USER}:${GROUP} ${TS_DIRECTORY}

VOLUME ["/data"]

COPY entrypoint.sh /entrypoint.sh

EXPOSE 9987/udp 10011 30033
ENTRYPOINT ["tini" , "/entrypoint.sh"]
