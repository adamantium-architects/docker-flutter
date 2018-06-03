FROM ubuntu:18.04

ENV ANDROID_HOME="/opt/android-sdk" \
    PATH="/opt/android-sdk/tools/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN apt-get update \
    && apt-get -y install --no-install-recommends curl git lib32stdc++6 openjdk-8-jdk-headless unzip xz-utils \
    && apt-get --purge autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b dev https://github.com/flutter/flutter.git /opt/flutter

RUN curl -O https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-3859397.zip -d /opt/android-sdk \
    && rm sdk-tools-linux-3859397.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && sdkmanager "tools" "build-tools;27.0.3" "platforms;android-27" \
    && yes | sdkmanager --licenses \
    && flutter doctor -v
