FROM alpine:3.7

ENV SERVER          0.0.0.0
ENV SERVER_PORT     8388
ENV PASSWORD=
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV OBFS            http_simple
ENV TIMEOUT         120


ARG WORK=~

RUN apk --no-cache add python \
    libsodium \
    wget

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/xie/master/xie-master.tar.gz | tar -xzf - -C $WORK

WORKDIR $WORK/xie-master/shadowsocks

CMD python server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v20180810/kcptun-linux-amd64-20180810.tar.gz | tar -xzf - -C $WORK
    
WORKDIR $WORK/kcptun-linux-amd64-20180810

CMD ./server_linux_amd64 -t "TARGET_IP:8388" -l ":4000" -mode fast2

