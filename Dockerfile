FROM alpine:3.8

ENV SERVER          0.0.0.0
ENV SERVER_PORT     8981
ENV LOCAL_PORT      1898
ENV PASSWORD=
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV OBFS            tls1.2_ticket_auth
ENV TIMEOUT         120
ENV UDP_TIMEOUT     60
ENV FAST_OPEN       true

ARG WORK=~

RUN apk --no-cache add python \
    libsodium \
    wget

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/xie/master/xie-master.tar.gz | tar -xzf - -C $WORK
WORKDIR $WORK/xie-master/shadowsocks

EXPOSE $SERVER_PORT/TCP
EXPOSE $SERVER_PORT/UDP
CMD python server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS
