# setting up system
FROM ubuntu:22.04
LABEL authors="DeeChael"
LABEL version="1.0.0"
LABEL description="Compilation environment"

# change apt mirrors to aliyun mirrors for faster packages installation
COPY sources.list /etc/apt
RUN cat /etc/apt/sources.list

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

# Install required packages
RUN apt update
RUN apt install -y --reinstall ca-certificates
RUN apt update
RUN apt install -y curl git vim gcc g++ make pkg-config autoconf automake patch libtool autopoint gperf \
    tcl8.6-dev wget unzip gccgo-go flex bison premake4 python3 python3-pip ninja-build meson sox gfortran \
    subversion build-essential module-assistant gcc-multilib g++-multilib libltdl7-dev cabextract \
    libboost-all-dev libxml2-utils gettext libxml-libxml-perl libxml2 libxml2-dev libxml-parser-perl \
    texinfo xmlto po4a libtool-bin yasm nasm xutils-dev libx11-dev xtrans-dev doxygen libssl-dev

# upgrade meson to latest
RUN pip3 install --user --upgrade meson

# create symbolic link for python
WORKDIR /usr/bin
RUN ln -fs python3 python

# setup rust environment
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN source ~/.cargo/env
RUN rustup target add aarch64-unknown-linux-ohos
RUN rustup target add armv7-unknown-linux-ohos
COPY config.toml /root/.cargo

# install cargo-c to compile rust libraries to .so or .a
RUN cargo install cargo-c

WORKDIR /data/bin

# download sdk
RUN curl --insecure --output /data/bin/sdk.tar.gz.aa "https://github.com/openharmony-rs/ohos-sdk/releases/download/v5.0.2/ohos-sdk-windows_linux-public.tar.gz.aa"
RUN curl --insecure --output /data/bin/sdk.tar.gz.ab "https://github.com/openharmony-rs/ohos-sdk/releases/download/v5.0.2/ohos-sdk-windows_linux-public.tar.gz.ab"
RUN curl --insecure --output /data/bin/sdk.tar.gz.ac "https://github.com/openharmony-rs/ohos-sdk/releases/download/v5.0.2/ohos-sdk-windows_linux-public.tar.gz.ac"
# combine sdk file
RUN cat /data/bin/sdk.tar.gz.aa /data/bin/sdk.tar.gz.ab /data/bin/sdk.tar.gz.ac > /data/bin/sdk.tar.gz
# decompress
RUN tar -zxvf /data/bin/sdk.tar.gz
RUN for i in /data/bin/sdk/linux/*.zip;do unzip ${i};done
# remove unneccesary files
RUN rm -rf /data/bin/sdk.tar.gz
RUN rm -rf /data/bin/sdk/windows
RUN rm -rf /data/bin/sdk/linux/*.zip

RUN mkdir -p /data/ohos

ENV OHOS_SDK=/data/bin/sdk/linux

WORKDIR /data
CMD /bin/bash
