FROM alpine:3.8

ENV SERVER          0.0.0.0
ENV SERVER_PORT     8981
ENV PASSWORD=
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV PROTOCOLPARAM   32
ENV OBFS            tls1.2_ticket_auth_compatible
ENV TIMEOUT         120
ENV UDP_TIMEOUT     60
ENV DNS_ADDR        8.8.8.8
ENV DNS_ADDR_2      8.8.4.4

ARG WORK=~

RUN apk --no-cache add python \
    libsodium \
    wget

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/xie/master/xie-master.tar.gz | tar -xzf - -C $WORK

WORKDIR $WORK/xie-master/shadowsocks

EXPOSE $SERVER_PORT
CMD python server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS -G $PROTOCOLPARAM
