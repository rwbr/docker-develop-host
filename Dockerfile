############################################################
# Dockerfile to build development container images
# Based on Ubuntu 14.04 LTS
############################################################

FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Ralf Weinbrecher

# make bash the system default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# set up locales
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

# Update the repository sources list
RUN apt-get update

# Install required packages
RUN apt-get install -y gawk flex gettext subversion git intltool ccache build-essential libssl-dev python-yaml

# Fixes empty home
ENV HOME /root
# add custom ssh config / keys to the root user
ADD .ssh/ /root/.ssh/
# Fixes permission if needed
RUN chmod 600 /root/.ssh/*

# Avoid first connection host confirmation
RUN ssh-keyscan -p2200 gitlab.agfeo.de > /root/.ssh/known_hosts

# Inject the OpenWRT code directory into the container
WORKDIR /root/openwrt
ADD openwrt /root/openwrt
RUN cd /root/openwrt
RUN git submodule init
RUN git submodule update