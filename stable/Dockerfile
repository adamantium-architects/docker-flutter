FROM ubuntu:18.04

ENV ANDROID_HOME="/opt/android-sdk" \
    PATH="/opt/android-sdk/tools/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN apt-get update \
    && apt-get -y install --no-install-recommends curl git lib32stdc++6 openjdk-8-jdk-headless unzip \
    && apt-get --purge autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b stable https://github.com/flutter/flutter.git /opt/flutter \
    && cd /opt/flutter \
    && git reset --hard $(git rev-list -1 $(git describe --tags @{u}))

RUN curl -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk \
    && rm sdk-tools-linux-4333796.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && sdkmanager "tools" "build-tools;28.0.3" "platforms;android-28" "platform-tools" \
    && yes | sdkmanager --licenses \
    && flutter doctor -v \
    && chown -R root:root /opt
