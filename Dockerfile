FROM ubuntu

MAINTAINER YOGESH LAKHOTIA

WORKDIR /

SHELL ["/bin/bash", "-c"]
RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y openjdk-8-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

ARG GRADLE_VERSION=6.2
ARG ANDROID_API_LEVEL=29
ARG ANDROID_BUILD_TOOLS_LEVEL=29.0.2
ARG EMULATOR_NAME='test'

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -P /tmp \
&& unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-all.zip \
&& mkdir /opt/gradlew \
&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper --gradle-version ${GRADLE_VERSION} --distribution-type all -p /opt/gradlew  \
&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper -p /opt/gradlew

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp \
&& unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-30;google_apis;x86" "platforms;android-29" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses


ENV GRADLE_HOME=/opt/gradle/gradle-$GRADLE_VERSION
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

RUN apt-get install -y build-essential apt-transport-https lsb-release ca-certificates curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g google-playstore-publisher
RUN npm install -g firebase-tools
RUN firebase --version
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

RUN rm /tmp/gradle-${GRADLE_VERSION}-all.zip
RUN rm /tmp/sdk-tools-linux-4333796.zip