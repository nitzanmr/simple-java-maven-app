# Use an official Maven image as the base image
FROM maven:3.9.2 AS build
# Set the working directory in the container
WORKDIR /app
# Copy the pom.xml and the project files to the container
COPY pom.xml .
COPY src ./src
# Build the application using Maven
RUN mvn versions:set -DnewVersion=$INPUT_VERSION
RUN mvn clean package -Dskiptests
# Use an official OpenJDK image as the base image
FROM openjdk:17-slim
# Set the working directory in the container
WORKDIR /app
# Copy the built JAR file from the previous stage to the container
COPY --from=build /app/target/my-app-$INPUT_VERSION-SNAPSHOT.jar .
# Set the command to run the application
CMD ["java", "-jar", "my-app-$INPUT_VERSION-SNAPSHOT.jar"]
