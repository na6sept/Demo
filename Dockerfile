# ------------------------------
# Stage 1: Build the application
# ------------------------------
FROM maven:3.9.3-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the app (skip tests if desired)
RUN mvn clean package -DskipTests

# --------------------------------------------
# Stage 2: Use a lightweight image to run app
# --------------------------------------------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy only the built JAR from the builder stage
COPY --from=builder /app/target/learn-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
