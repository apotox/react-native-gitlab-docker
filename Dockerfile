FROM openjdk:8

LABEL MAINTAINER SAPHI
LABEL VERSION 1
LABEL AUTHOR_EMAIL saphidev@gmail.com

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get -y install nodejs unzip

ENV ANDROID_COMPILE_SDK 28
ENV ANDROID_SDK_VERSION r28.0.3
ENV ANDROID_BUILD_TOOLS_VERSION build-tools-28.0.3


# ENV VARIABLES
ENV ANDROID_SDK_FILENAME=android-sdk_${ANDROID_SDK_VERSION}-linux.tgz \
    ANDROID_SDK_URL=http://dl.google.com/android/${ANDROID_SDK_FILENAME} \
    ANDROID_HOME="/usr/local/android-sdk" \
    MAVEN_VERSION=3.6.3

WORKDIR ${ANDROID_HOME}
# GET SDK MANAGER
RUN curl -sL -o android.zip ${ANDROID_SDK_URL} && unzip android.zip && rm android.zip
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# ANDROID SDK AND PLATFORM
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# ——————————
# Installs Gradle
# ——————————

# Gradle
ENV GRADLE_VERSION 3.5.2

RUN cd /usr/lib \
 && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip"

# MAVEN
RUN curl -sL -o maven.zip https://www-us.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
    mkdir /opt/maven && unzip -d /opt/maven maven.zip && rm maven.zip

# ADD PATH TO BASHRC
RUN export PATH=$PATH:$ANDROID_HOME/emulator\
    && export PATH=$PATH:$ANDROID_HOME/tools\
    && export PATH=$PATH:$ANDROID_HOME/tools/bin\
    && export PATH=$PATH:/opt/gradle/gradle-${GRADLE_VERSION}/bin\
    && export PATH=$PATH:/opt/maven/apache-maven-${MAVEN_VERSION}/bin\
    && echo PATH=$PATH:$ANDROID_HOME/platform-tools>>/etc/bash.bashrc

# ——————————
# Install Basic React-Native packages
# ——————————
RUN npm install react-native-cli -g
RUN npm install yarn -g

ENV LANG en_US.UTF-8
