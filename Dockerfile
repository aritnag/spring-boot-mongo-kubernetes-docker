FROM openjdk:8-jdk-alpine
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
# Install project dependencies and keep sources
# make source folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# install maven dependency packages (keep in image)
COPY pom.xml /usr/src/app
# copy other source files (keep in image)
COPY src /usr/src/app/src
# package the contents
COPY Dockerfile /usr/src/app
RUN rm -rf target && mvn -T 1C package


WORKDIR /usr/src/app/target/
RUN ls

ENTRYPOINT ["/usr/bin/java", "-jar", "/usr/share/spring-boot-mongo-service/spring-boot-mongo-service.jar"]

# Add Maven dependencies (not shaded into the artifact; Docker-cached)
ADD target/lib           /usr/share/spring-boot-mongo-service/lib
# Add the service itself
ARG JAR_FILE
ADD target/${JAR_FILE} /usr/share/spring-boot-mongo-service/spring-boot-mongo-service.jar