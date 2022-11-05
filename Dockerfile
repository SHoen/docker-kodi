# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2021 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


## using ARM 32 bit userspace to be able to run WIDEVINE e.g. for NETFLIX
FROM arm32v7/ubuntu:kinetic

ARG KODI_VERSION=20.0

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

# Add 32 bit packages
RUN dpkg --add-architecture armhf &&  apt update
RUN apt-get update                                                   && \
    apt-get install kodi  -y                                         && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get install kodi  -y   
RUN apt-get install libraspberrypi0 -y                          

ARG KODI_EXTRA_PACKAGES=

RUN packages="                                               \
    ca-certificates                                          \
    kodi-eventclients-kodi-send                              \
    kodi-inputstream-adaptive                                \
    kodi-inputstream-ffmpegdirect                                \
    kodi-inputstream-rtmp                                    \
    kodi-peripheral-joystick                                 \
    kodi-peripheral-xarcade                                  \
    kodi-peripheral-xarcade                                  \
    kodi-pvr-argustv                                         \
    kodi-pvr-dvblink                                         \
    kodi-pvr-dvbviewer                                       \
    kodi-pvr-filmon                                          \
    kodi-pvr-hdhomerun                                       \
    kodi-pvr-hts                                             \
    kodi-pvr-iptvsimple                                      \
    kodi-pvr-mediaportal-tvserver                            \
    kodi-pvr-mythtv                                          \
    kodi-pvr-nextpvr                                         \
    kodi-pvr-njoy                                            \
    kodi-pvr-octonet                                         \
    kodi-pvr-pctv                                            \
    kodi-pvr-sledovanitv-cz                                  \
    kodi-pvr-stalker                                         \
    kodi-pvr-teleboy                                         \
    kodi-pvr-vbox                                            \
    kodi-pvr-vdr-vnsi                                        \
    kodi-pvr-vuplus                                          \
    kodi-pvr-wmc                                             \
    kodi-pvr-zattoo                                          \
    kodi-screensaver-asteroids                               \
    kodi-screensaver-biogenesis                              \
    kodi-screensaver-greynetic                               \
    kodi-screensaver-pingpong                                \
    kodi-screensaver-pyro                                    \
    locales                                                  \
    pulseaudio                                               \
    tzdata                                                   \
    build-essential                                            \
    libnss3                                                 \
    python3-pip                                             \
    va-driver-all"                                        && \
                                                             \
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*

#Install for Netflix Addon see 
RUN pip3 install --user pycryptodomex

#Get working widevine for Error on Inputstream e.g. on NETFLIX with input stream helper see 
# https://github.com/CastagnaIT/plugin.video.netflix/issues/1154#issuecomment-837286703
RUN wget https://k.slyguy.xyz/.decryptmodules/widevine/4.10.1679.0-linux-armv7.so -o /storage/.kodi/cdm/libwidevinecdm.so
COPY entrypoint.sh /usr/local/bin

# setup entry point
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
