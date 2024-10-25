# Use the official OpenJDK 17 base image for building and running the application
FROM openjdk:17-slim AS build

# Install any necessary packages
RUN apt-get update && apt-get install -y bash

# Set the working directory for the build process
WORKDIR /app 

# Copy Maven wrapper and project files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src ./src

# Give execution permissions to the Maven wrapper
RUN chmod +x mvnw

# Build the application using the Maven wrapper
RUN ./mvnw package

# Use the same OpenJDK 17-slim image for the runtime
FROM openjdk:17-slim

# Set the working directory for the runtime
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]