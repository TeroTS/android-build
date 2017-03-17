FROM ubuntu:16.04

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
    ANDROID_APIS="android-14,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25" \
    ANDROID_HOME="/opt/android"

# Install java
RUN apt-get update && apt-get install -yq software-properties-common && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git unzip wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 curl python-pip python-setuptools parallel

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION

RUN apt-get -y install lib32stdc++6 lib32z1 python-openssl && \
    mkdir -p ${ANDROID_HOME}  && cd ${ANDROID_HOME} && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    pip install --upgrade google-api-python-client oauth2client tinys3 urllib3 trollop onesky-python && \
    echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
    mkdir -p ${ANDROID_HOME}/licenses && \
    apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the licenses, WARNING if SDK updated the licenses need to be updated also

COPY licenses ${ANDROID_HOME}/licenses

RUN which adb
RUN which android


# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace



