# See base-image/image
FROM schachr/raspbian-stretch

COPY bin/install_clean /usr/bin/install_clean
COPY rpilibs.tar.gz /rpilibs.tar.gz
RUN tar zxvf /rpilibs.tar.gz
RUN rm /rpilibs.tar.gz
RUN chmod 777 /usr/bin/install_clean
RUN echo "deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list

#This was the original apt-build that was working in v.002, but added pulseaudio and others
#RUN install_clean libc6 libcairo2 libfreetype6 libgcc1 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libgtk2.0-0 libpango-1.0-0 libpangocairo-1.0-0 \
#    libsm6 libsndio6.1 libstdc++6 libx11-6 libxxf86vm1 wget 

RUN install_clean libc6 libcairo2 libfreetype6 libgcc1 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libgtk2.0-0 libpango-1.0-0 libpangocairo-1.0-0 \
    libsm6 libsndio6.1 libstdc++6 libx11-6 libxxf86vm1 wget pulseaudio pulseaudio-utils libgl1-mesa-glx libgl1-mesa-dri libva1 libgl1-mesa-glx \
    libgl1-mesa-dri

# Parsec Client
RUN wget --no-check-certificate "https://s3.amazonaws.com/parsec-build/package/parsec-rpi.deb" -O parsec-rpi.deb
RUN dpkg --ignore-depends libsndio6.1 -i parsec-rpi.deb # --ignore-depends fixes libsndio
RUN rm parsec-rpi.deb
RUN apt-get remove -y wget

# Setup pulseaudio
COPY pulse-config.conf /etc/pulse/client.conf

# add a parsec user
RUN groupadd --gid 1000 parsec \
&&  useradd --gid 1000 --uid 1000 -m parsec \
&&  usermod -aG video parsec \
&&  mkdir -p /home/parsec/.parsec \
&&  chown parsec:parsec /home/parsec/.parsec

RUN apt -y autoremove
# parsec config
USER parsec
COPY config.txt /home/parsec/.parsec/config.txt
ENTRYPOINT [ "/usr/bin/parsec" ]
