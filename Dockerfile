FROM debian:stretch-20210326
# FROM debian:stretch-20211201-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --fix-missing && apt upgrade -f -y --no-install-recommends

RUN apt install -y -f --no-install-recommends sudo systemd nano procps curl ca-certificates dhcpcd5

COPY setupVars.conf /etc/pivpn/

ARG pivpnFilesDir=/etc/pivpn
ARG PIVPN_TEST=false
ARG PLAT=Debian
ARG useUpdateVars=true
ARG SUDO=
ARG SUDOE=
ARG INSTALLER=/var/tmp/install.sh

RUN curl -fsSL0 https://install.pivpn.io -o "${INSTALLER}" \
    && sed -i 's/debconf-apt-progress --//g' "${INSTALLER}" \
    && sed -i '/systemctl start/d' "${INSTALLER}" \
    && sed -i '/setStaticIPv4 #/d' "${INSTALLER}" \
    && chmod +x "${INSTALLER}" \
    && "${INSTALLER}" --unattended /etc/pivpn/setupVars.conf --reconfigure
    
#RUN ls /opt/pivpn/
#RUN cp -r /opt/pivpn/ /var/tmp/pivpn/
RUN apt clean \
    && rm -rf /var/lib/apt/lists/*  /etc/openvpn/* /home/pivpn/ovpns/* /var/tmp/*
    # /var/tmp/* /usr/local/src/*
RUN ls /opt/pivpn/ || true
#RUN rm -rf /opt/*
#RUN cp -rf /var/tmp/pivpn/ /opt/pivpn/
#RUN rm -rf /var/tmp/*
#RUN ls /opt/pivpn/

WORKDIR /home/pivpn
COPY run .
RUN chmod +x /home/pivpn/run
CMD ["./run"]    
