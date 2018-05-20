FROM ubuntu:18.04

ENV ANDROID_HOME="/opt/android-sdk" \
    PATH="/opt/android-sdk/tools/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN apt-get update \
    && apt-get -y install --no-install-recommends curl git lib32stdc++6 openjdk-8-jdk-headless unzip xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get --purge autoremove \
    && apt-get autoclean

RUN curl -O https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_v0.3.2-beta.tar.xz \
    && tar -xf flutter_linux_v0.3.2-beta.tar.xz -C /opt \
    && rm flutter_linux_v0.3.2-beta.tar.xz

RUN curl -O https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-3859397.zip -d /opt/android-sdk \
    && rm sdk-tools-linux-3859397.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && sdkmanager "tools" "build-tools;27.0.3" "platforms;android-27" \
    && yes | sdkmanager --licenses
