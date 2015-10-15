FROM ubuntu
MAINTAINER Mark J. Reed <markjreed@gmail.com>
RUN dpkg --add-architecture i386
RUN apt-get install -qqy software-properties-common
RUN add-apt-repository ppa:avsm/ppa
RUN apt-get -qq update
RUN apt-get install -qqy libc6:i386 libstdc++6:i386 gcc-multilib
RUN apt-get install -qqy build-essential curl git unzip libxt6 python-software-properties
RUN apt-get install -qqy jq racket algol68g gnat dosbox ocaml opam
RUN mkdir /foxtrot
ADD . /foxtrot
WORKDIR /foxtrot
RUN curl -sS -L --remote-name-all ftp://ftp.gnu.org/pub/gnu/apl/apl-1.5.tar.gz https://github.com/Leushenko/ybc/releases/download/v0.5-linux/ybc.zip http://www.nicholson.com/rhn/files/cbas367b5-linux-x86_64.zip
RUN tar xzf apl-1.5.tar.gz && cd apl-1.5 && make install
RUN unzip cbas367b5-linux-x86_64.zip
RUN unzip ybc.zip
