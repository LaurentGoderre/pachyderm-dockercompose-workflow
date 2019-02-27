FROM postgres

RUN apt update -q \
  && apt install -qy \
    iproute2 \
  && apt clean

COPY * /root/
