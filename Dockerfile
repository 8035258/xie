FROM alpine:3.7

ENV SERVER          0.0.0.0
ENV SERVER_PORT     8981
ENV LOCAL_PORT      1989
ENV PASSWORD=
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV OBFS            http_simple
ENV TIMEOUT         120
ENV UDP_TIMEOUT     60

ARG WORK=~

RUN apk --no-cache add python \
    libsodium \
    wget

RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh
RUN mv net_speeder /usr/local/bin/
RUN /usr/local/bin/net_speeder

RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/8035258/ssr/master/ssr-master.tar.gz | tar -xzf - -C $WORK
WORKDIR $WORK/ssr-master/shadowsocks

EXPOSE $SERVER_PORT/TCP
EXPOSE $SERVER_PORT/UDP
CMD python server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS
