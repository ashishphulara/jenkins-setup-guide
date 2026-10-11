# Installing Jenkins with Docker & Docker Compose 🐳

Running Jenkins in Docker provides quick setup, version control over the runtime environment, and simple disaster recovery.

---

## 1. Prerequisites

Make sure Docker and Docker Compose are installed and running:
```bash
docker --version
docker compose version
```

---

## 2. Option A: Run Jenkins with Docker CLI

For a quick setup, launch the official Jenkins LTS image:

```bash
docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts-jdk17
```

### Explanation of flags:
- `-d`: Run container in detached mode (background).
- `--name jenkins`: Friendly name for the container.
- `--restart=unless-stopped`: Ensure container restarts if host reboots.
- `-p 8080:8080`: Expose Jenkins Web UI to host port `8080`.
- `-p 50000:50000`: Expose port for JNLP agent communication.
- `-v jenkins_data:/var/jenkins_home`: Persist Jenkins configuration, job history, and workspace files in a named volume.
- `-v /var/run/docker.sock:/var/run/docker.sock`: Allows Jenkins jobs to trigger Docker builds on the host engine.

---

## 3. Option B: Production Setup with Docker Compose

Using `docker-compose.yml` makes configurations reproducible and easy to manage.

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts-jdk17
    container_name: jenkins-server
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "50000:50000"
    environment:
      - TZ=UTC
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=true -Xmx2048m
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins-net

volumes:
  jenkins_home:
    driver: local

networks:
  jenkins-net:
    driver: bridge
```

### Starting the Jenkins Container:
```bash
docker compose up -d
```

### Checking Container Logs:
```bash
docker compose logs -f jenkins
```

### Stopping and Restarting:
```bash
# Stop without deleting data
docker compose down

# Start again
docker compose up -d
```

---

## 4. Building a Custom Jenkins Image with Docker CLI Pre-installed

If your pipelines need to execute `docker build` or `docker run` commands directly inside Jenkins, build a custom image with the Docker CLI installed:

### `Dockerfile`:
```dockerfile
FROM jenkins/jenkins:lts-jdk17
USER root

# Install Docker CLI dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker official GPG key and repo
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Return to jenkins user
USER jenkins
```

Build and run:
```bash
docker build -t custom-jenkins:latest .
docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock custom-jenkins:latest
```

---

## 5. Next Step

Retrieve the unlock key and access Jenkins:
👉 [Step 3: Initial Setup & Unlock Wizard](../03-initial-setup/README.md)
