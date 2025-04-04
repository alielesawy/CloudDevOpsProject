FROM openjdk:17-jdk-slim

WORKDIR /app

COPY gradlew build.gradle settings.gradle /app/
COPY gradle /app/gradle
COPY src /app/src

RUN chmod +x gradlew
RUN ./gradlew build --no-daemon
CMD ["java", "-jar", "build/libs/demo-0.0.1-SNAPSHOT.jar"]
