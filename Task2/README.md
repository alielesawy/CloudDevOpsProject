# 🚀 Spring Boot Gradle App – Dockerized Deployment

This steps I walks through for testing and containerizing a Spring Boot application using Gradle and Docker.

![](/assets/icons8-java-144.png) ![](/assets/icons8-spring-boot-160.png)  ![](/assets/icons8-docker-96.png) ![](/assets/Gradle.png)

---

## 🧪 Task 2

## Test App Locally

### 1. Grant Execution Permission for Gradle Wrapper

```bash
chmod +x gradlew
```

### 2. Build the App

```bash
./gradlew build
```

### 3. Run the App

```bash
./gradlew bootRun
```

🧾 **Demo**: See the attached image showing the local browser view confirming successful startup.
![](/assets/task2-TestLocal.png)
---

## 🐳 Dockerizing the App

### Dockerfile

Create a [`Dockerfile`](/Task2/Dockerfile) in the root of the app (inside `web-app/`):

```Dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY gradlew build.gradle settings.gradle /app/
COPY gradle /app/gradle
COPY src /app/src

RUN chmod +x gradlew
RUN ./gradlew build --no-daemon

CMD ["java", "-jar", "build/libs/demo-0.0.1-SNAPSHOT.jar"]
```

> 🔔 **Note**: Ensure that the JAR file name in the `CMD` line matches the actual output JAR in `build/libs/`.  
> You can verify this by checking the `rootProject.name` in `settings.gradle`.

---

## 🛠 Build & Run Docker Container

### 1. Navigate to the App Directory

```bash
cd web-app
```

### 2. Build Docker Image

```bash
docker build -t alyesmaeil/springboot-gradle-web-app .
```

🧾 **Demo**: See attached image showing Docker build logs.

![](/assets/task2-demoBuild.png)

### 3. Run the Container on Port 8088

```bash
docker run -p 8088:8080 alyesmaeil/springboot-gradle-web-app
```

🌐 Visit: [http://localhost:8088](http://localhost:8088)

🧾 **Demo**: See the attached image showing the app running in terminal and the browser.
![](/assets/task2-demoRunCon.png)
![](/assets/task2-demoViewCon.png)
---

## 📂 .dockerignore (Optional)

To optimize Docker build time and image size, add a `.dockerignore` file:

```bash
.gradle
build
out
*.iml
.idea
```

