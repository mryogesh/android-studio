FROM ubuntu

MAINTAINER YOGESH LAKHOTIA

WORKDIR /

ARG GRADLE_VERSION=6.2

SHELL ["/bin/bash", "-c"]
RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y openjdk-8-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

RUN mkdir -p  ~/.android && touch ~/.android/repositories.cfg

RUN wget 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.2.1.0/android-studio-ide-202.7351085-linux.tar.gz' -P /tmp

RUN gunzip -d /tmp/android-studio-ide-202.7351085-linux.tar.gz

RUN unzip -d /opt/gradle /tmp/gradle-6.2-all.zip \
&& mkdir /opt/gradlew \
&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper --gradle-version ${GRADLE_VERSION} --distribution-type all -p /opt/gradlew  \
&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper -p /opt/gradlew

RUN unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-30;google_apis;x86" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-27;google_apis;x86" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-23;google_apis;x86" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses

ENV GRADLE_HOME=/opt/gradle/gradle-6.2 \
ANDROID_HOME=/opt/android
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

RUN apt-get install -y build-essential apt-transport-https lsb-release ca-certificates curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g google-playstore-publisher
RUN npm install -g firebase-tools
RUN firebase --version
