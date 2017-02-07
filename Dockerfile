FROM ubuntu:16.04

ARG JAVA_PREREQUIREMENTS="software-properties-common"
ARG ANDROID_SDK_PACKAGES="platform,tool,platform-tool,extra,build-tools-24.0.3,extra-android-m2repository"

ENV ANDROID_SDK_VERSION r24.4.1
ENV ANDROID_NDK_VERSION r13

# Install the licenses, WARNING if SDK updated the licenses need to be updated also.
COPY licenses /usr/local/android-sdk-linux/licenses

# Setup java and accept license.
RUN apt-get update && apt-get install -y ${JAVA_PREREQUIREMENTS} \
    && add-apt-repository -y ppa:webupd8team/java \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get remove --purge -y ${JAVA_PREREQUIREMENTS} && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/*

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    git \
    expect \
    libc6-i386 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32stdc++6 \
    lib32z1 \
    oracle-java8-installer \
    oracle-java8-set-default \
    parallel \
    python-openssl \
    python-pip \
    python-setuptools \
    unzip \
    wget \
    && pip install --upgrade \
    google-api-python-client \
    oauth2client \
    onesky-python \
    tinys3 \
    trollop \
    urllib3 \

    # Install NDK.
    && wget https://dl.google.com/android/repository/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip \
    && unzip android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip \
    && mv android-ndk-$ANDROID_NDK_VERSION /usr/local/android-sdk-linux/ndk-bundle \
    && rm android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip \

    # Install SDK.
    && wget http://dl.google.com/android/android-sdk_$ANDROID_SDK_VERSION-linux.tgz \
    && tar -C /usr/local -xzf android-sdk_$ANDROID_SDK_VERSION-linux.tgz \
    && rm android-sdk_$ANDROID_SDK_VERSION-linux.tgz \
    && mkdir -p /opt/workspace \
    && (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk-linux/tools/android update sdk --filter ${ANDROID_SDK_PACKAGES} --no-ui --force && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/*

# Setup environment.
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Go to workspace.
WORKDIR /opt/workspace
