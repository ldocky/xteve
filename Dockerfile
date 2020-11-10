FROM ubuntu:focal
LABEL maintainer="ldocky"
RUN apk add curl vlc ffmpeg
ADD https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_amd64.zip /tmp/xteve_linux_amd64.zip

RUN mkdir -p /xteve
RUN unzip -o /tmp/xteve_linux_amd64.zip -d /xteve

RUN rm /tmp/xteve_linux_amd64.zip

RUN chmod +x /xteve/xteve

RUN addgroup -S xteve && adduser -S xteve -G xteve

USER xteve

RUN mkdir /home/xteve/.xteve/
RUN mkdir /home/xteve/.xteve/backup/
RUN mkdir /tmp/xteve

RUN chown xteve:xteve /home/xteve/.xteve/
RUN chown xteve:xteve /home/xteve/.xteve/backup/
RUN chown xteve:xteve /tmp/xteve

VOLUME /home/xteve/.xteve

EXPOSE 34400

HEALTHCHECK --interval=30s --start-period=30s --retries=3 --timeout=10s \
  CMD curl -f http://localhost:34400/ || exit 1
  
ENTRYPOINT ["/xteve/xteve"]

CMD ["-port=34400"]
