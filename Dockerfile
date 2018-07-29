FROM ubuntu:16.04
LABEL MAINTAINER Michael Laccetti <michael@laccetti.com> <https://laccetti.com/)

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

RUN apt-get update && \
    apt-get upgrade && \
  apt-get install -y --no-install-recommends locales && \
  locale-gen en_US.UTF-8 && \
  apt-get dist-upgrade -y && \
  apt-get --purge remove openjdk* && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
  apt-get clean all
# ----
# Install Maven
RUN apt-get add --no-cache curl tar bash
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
ENTRYPOINT ["/usr/bin/mvn"]
# ----
# Install GIT
RUN apt-get update
RUN apt-get install git-core
RUN git --version
# Install project dependencies and keep sources
# make source folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# install maven dependency packages (keep in image)
#COPY pom.xml /usr/src/app
# copy other source files (keep in image)
#COPY src /usr/src/app/src
# package the contents
#COPY Dockerfile /usr/src/app
RUN git clone https://github.com/aritnag/spring-boot-mongo-kubernetes-docker.git
RUN rm -rf target && mvn -T 1C package


#WORKDIR /usr/src/app/target/
#RUN ls

#Execute the JAR
#ARG artifactid
#ARG version
#ENV artifact ${artifactid}-${version}.jar 

#COPY /target/spring-boot-mongo-docker-*.jar  app.jar
#ENV JAVA_OPTS=""
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar
#EXPOSE 8080
#ENTRYPOINT ["sh", "-c"]
#CMD ["java -jar spring-boot-mongo-docker-*.jar"] 