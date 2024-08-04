FROM buildpack-deps as builder

ARG UDPXY_SRC_URL
ENV UDPXY_SRC_URL=${UDPXY_SRC_URL:-"https://github.com/pcherenkov/udpxy/archive/refs/tags/1.0-25.1.tar.gz"}

WORKDIR /tmp
RUN wget -O udpxy-src.tar.gz ${UDPXY_SRC_URL}
RUN tar -xzvf udpxy-src.tar.gz
RUN cd udpxy-* && cd chipmunk && make && make install

FROM debian:stable

COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/udpxy
COPY --from=builder /usr/local/bin/udpxrec /usr/local/bin/udpxrec

ENTRYPOINT ["/usr/local/bin/udpxy"]
CMD ["-v", "-T", "-p", "4022"]
