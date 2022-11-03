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

FROM ubuntu:kinetic

ARG KODI_VERSION=20.0

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update                                                        && \
    apt-get install kodi  -y                                        && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get install kodi  -y   
RUN apt-get install libraspberrypi0 -y                          

ARG KODI_EXTRA_PACKAGES=

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
#  - va-driver-all                the full suite of drivers for the Video Acceleration API (VA API)
#  - kodi-game-libretro-*         Libretro cores (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
#  - kodi-pvr-*                   PVR add-ons (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
#  - kodi-screensaver-*           additional screensavers (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
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
    va-driver-all"                                        && \
                                                             \
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*
#
# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
