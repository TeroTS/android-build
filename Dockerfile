FROM ubuntu:16.04

# Install java
RUN apt-get update && apt-get install -yq software-properties-common && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 curl python-pip python-setuptools


RUN apt-get -y install lib32stdc++6 lib32z1 python-openssl && \
    wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar -C /usr/local -xzf android-sdk_r24.4.1-linux.tgz && \
    pip install --upgrade google-api-python-client oauth2client tinys3 urllib3 trollop onesky-python && \
    rm android-sdk_r24.4.1-linux.tgz && \
    (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk-linux/tools/android update sdk --filter platform,tool,platform-tool,extra,build-tools-24.0.1 --no-ui --force -a

# Setup environment
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN which adb
RUN which android

# Cleaning
RUN apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
