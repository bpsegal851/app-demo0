FROM ubuntu:bionic
WORKDIR /git
RUN apt-get update && apt-get install -y cmake git libdbus-1-dev libdbus-glib-1-dev libcurl4-openssl-dev libgcrypt20-dev libselinux1-dev libxslt1-dev libgconf2-dev libacl1-dev libblkid-dev libcap-dev libxml2-dev libldap2-dev libpcre3-dev python-dev swig libxml-parser-perl libxml-xpath-perl libperl-dev libbz2-dev librpm-dev g++ libapt-pkg-dev
RUN git clone https://github.com/OpenSCAP/openscap.git && cd openscap && git checkout tags/1.3.1
WORKDIR /git/openscap/build
RUN cmake ../ && make
RUN make install
WORKDIR /git
RUN apt-get install -y cmake make expat libxml2-utils ninja-build python3-jinja2 python3-yaml xsltproc
RUN git clone https://github.com/ComplianceAsCode/content.git && cd content && git checkout tags/v0.1.47
WORKDIR /git/content/build
RUN cmake ../ && make -j4
RUN make install

WORKDIR /git
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y qtbase5-dev libqt5xmlpatterns5-dev asciidoc
RUN git clone -b v1-2 https://github.com/OpenSCAP/scap-workbench.git

WORKDIR /git/scap-workbench/build
RUN cmake -DSCAP_WORKBENCH_SCAP_CONTENT_DIRECTORY:PATH=/usr/local/share/xml/scap -DSCAP_WORKBENCH_SSG_DIRECTORY:FILEPATH=/usr/local/share/xml/scap/ssg/content ../ && make
RUN make install

RUN apt-get install -y xfce4 xfce4-goodies
RUN apt-get install -y tigervnc-common tigervnc-standalone-server tigervnc-xorg-extension
COPY .vnc /root/.vnc
EXPOSE 5901
