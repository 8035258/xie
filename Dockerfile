FROM alpine:3.7

ENV SERVER          0.0.0.0
ENV SERVER_PORT     8981
ENV PASSWORD=
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV OBFS            http_simple
ENV TIMEOUT         120
ENV TARGET          127.0.0.1:8981
ENV LISTEN          4000
ENV MODE            fast2

ARG WORK=~

RUN apk --no-cache add python \
    libsodium \
    wget

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/xie/master/xie-master.tar.gz | tar -xzf - -C $WORK

WORKDIR $WORK/xie-master/shadowsocks

CMD python server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/xie/master/kcptun.tar.gz | tar -xzf - -C $WORK
    
WORKDIR $WORK/kcptun

CMD server_linux_amd64 -t $TARGET -l $LISTEN -mode $MODE

