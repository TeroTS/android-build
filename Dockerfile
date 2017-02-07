FROM ubuntu:16.04

ENV ANDROID_APIS="android-25" \
    ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
    ANDROID_HOME="/opt/android" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \
    JAVA_PREREQUIREMENTS="software-properties-common"

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

# Setup java and accept java license.
RUN apt-get update && apt-get install -y ${JAVA_PREREQUIREMENTS} && \
    add-apt-repository -y ppa:webupd8team/java && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
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
    python-pip \
    python-setuptools \
    unzip \
    wget \

    && pip install --upgrade pip && pip install --upgrade \
    boto3 \
    google-api-python-client \
    oauth2client \
    onesky-python \
    trollop \
    urllib3 \

    # Install SDK.
    && mkdir -p ${ANDROID_HOME}  && cd ${ANDROID_HOME} && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},extra-android-m2repository && \
    mkdir -p ${ANDROID_HOME}/licenses && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY licenses ${ANDROID_HOME}/licenses

# Setup environment.
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Go to workspace.
WORKDIR /opt/workspace
