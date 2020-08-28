FROM ubuntu:20.04
RUN dpkg --add-architecture i386
RUN apt-get install -qqy software-properties-common
RUN add-apt-repository ppa:avsm/ppa
RUN apt-get -qq update
RUN apt-get install -qqy libc6:i386 libstdc++6:i386 gcc-multilib
RUN apt-get install -qqy unzip libxt6 python3-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential curl git jq vim apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
COPY . /opt/foxtrot
#RUN apt-get -y install linux-libc-dev-i386 libxft2-i386 g++-multilib \
#    gcc-multilib libxpm-dev:i386 libxxf86vm-dev:i386 libgl1-mesa-dev:i386 \
#    libglu1-mesa-dev:i386 && \
#    git clone https://github.com/blitz-research/blitzmax &&  \
#    cd blitzmax/_src/linux_x86 && chmod +x *.bat && ./install.bat
#RUN curl -LO \
#    "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.40.5_with_keytrans.tar.gz" \
#    && tar xzf yaze-ag-2.4*trans.tar.gz && cd yaze-ag-2.4*trans && \
#    make -f Makefile_linux_64_intel_corei7 install
RUN /opt/foxtrot/install_packages
RUN mkdir ~/.lein && cp profiles.clj ~/.lein
RUN DEBIAN_FRONT_END=noninteractive apt-get -y install npm && npm install -g typescript
