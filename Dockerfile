# Ubuntu 15.04 with Java 8 installed.
# Build image with:  docker build -t krizsan/ubuntu1504java8:v1 .
FROM ubuntu:15.04
MAINTAINER Ivan Krizsan, https://github.com/krizsan
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
# ----
# Install Maven
RUN apk add --no-cache curl tar bash
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