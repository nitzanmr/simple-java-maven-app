# Use an official Maven image as the base image
FROM maven:3.9.2 AS build

ARG DOCKER_VERSION

WORKDIR /app
# copy the project files to container
COPY pom.xml .
COPY src ./src
# setting the version to be given version
RUN mvn versions:set -DnewVersion=$DOCKER_VERSION
# packaging the maven package
RUN mvn clean package -Dskiptests

# Use an official OpenJDK image as the base image
FROM openjdk:17-slim
ARG DOCKER_VERSION
WORKDIR /app
# copying the jar file to the new container
COPY --from=build /app/target/my-app-$INPUT_DOCKER_VERSION.jar .
# Set the command to run the application
CMD ["java", "-jar", "my-app-$DOCKER_VERSION.jar"]
