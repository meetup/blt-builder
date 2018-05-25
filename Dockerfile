FROM openjdk:8u111-jdk

RUN apt-get update && apt-get install -y --no-install-recommends \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
ENV DOCKER_BUCKET get.docker.com

ENV DOCKER_VERSION 1.10.1
ENV DOCKER_SHA256 de4057057acd259ec38b5244a40d806993e2ca219e9869ace133fad0e09cedf2

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
    && echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
    && chmod +x /usr/local/bin/docker

ENV SBT_VERSION 0.13.12

# Install SBT
RUN cd /usr/local && \
    wget https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
    tar -xf sbt-${SBT_VERSION}.tgz && \
    rm sbt-${SBT_VERSION}.tgz && \
    ln -s /usr/local/sbt/bin/sbt /usr/bin/sbt

WORKDIR /data

ENV LANG C.UTF-8

CMD ["make", "package-sbt"]
