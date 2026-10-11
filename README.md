# Jenkins Setup Guide 🚀

A comprehensive, production-ready guide to installing, configuring, securing, and maintaining **Jenkins CI/CD Automation Server**.

---

## 📋 Table of Contents

- [Overview & Prerequisites](#-overview--prerequisites)
- [Installation Methods](#-installation-methods)
  - [Option 1: Ubuntu / Debian (Native Package)](#option-1-ubuntu--debian)
  - [Option 2: Docker & Docker Compose (Recommended for Containers)](#option-2-docker--docker-compose)
  - [Option 3: RHEL / CentOS / Rocky Linux / Amazon Linux](#option-3-rhel--centos--rocky-linux--amazon-linux)
  - [Option 4: Windows](#option-4-windows)
- [Initial Setup Wizard](#-initial-setup-wizard)
- [Post-Installation & Service Management](#-post-installation--service-management)
  - [Managing the Systemd Service](#managing-the-systemd-service)
  - [Changing Default Port (8080)](#changing-default-port-8080)
  - [Configuring Nginx Reverse Proxy & SSL](#configuring-nginx-reverse-proxy--ssl)
- [Essential Plugins & Tools](#-essential-plugins--tools)
- [Creating Your First Declarative Pipeline](#-creating-your-first-declarative-pipeline)
- [Troubleshooting & FAQs](#-troubleshooting--faqs)
- [Repository Structure & Roadmap](#-repository-structure--roadmap)
- [License](#-license)

---

## 🔍 Overview & Prerequisites

**Jenkins** is an open-source automation server that enables developers to reliably build, test, and deploy their software.

### Hardware Requirements
- **Minimum:** 1 vCPU, 1 GB RAM (for lightweight evaluation only)
- **Recommended (Small/Medium Teams):** 2–4 vCPUs, 4–8 GB RAM, 50+ GB SSD storage

### Software & Network Prerequisites
- **Java Runtime Environment:** Jenkins requires Java 17 or Java 21 (Java 8 and 11 are deprecated / unsupported in current LTS releases).
- **Network Ports:** Default inbound port `8080` (HTTP) and `50000` (JNLP agent communication).
- **Root/Sudo Access:** Required for native package installation.

---

## 💻 Installation Methods

### Option 1: Ubuntu / Debian

#### 1. Update system packages and install OpenJDK 17
```bash
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre
java -version
```

#### 2. Add Jenkins Debian Repository and GPG Key
```bash
# Add Jenkins GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository to apt sources
echo deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

#### 3. Install and Start Jenkins
```bash
sudo apt update
sudo apt install -y jenkins

# Enable Jenkins on boot and start the service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Verify service status
sudo systemctl status jenkins
```

#### 4. Configure Firewall (UFW)
```bash
sudo ufw allow 8080/tcp
sudo ufw status
```

---

### Option 2: Docker & Docker Compose

Running Jenkins inside Docker isolates dependencies and makes backups/upgrades straightforward.

#### Quick Run with Docker CLI
```bash
docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts-jdk17
```

#### Production Run with Docker Compose (`docker-compose.yml`)
Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts-jdk17
    container_name: jenkins-server
    restart: unless-stopped
    privileged: false
    user: root # Needed if using host docker.sock; alternatively set appropriate docker group GID
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=UTC
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=true

volumes:
  jenkins_data:
```

Start the container:
```bash
docker compose up -d
docker compose logs -f jenkins
```

---

### Option 3: RHEL / CentOS / Rocky Linux / Amazon Linux

```bash
# 1. Install Java 17
sudo dnf install -y fontconfig java-17-openjdk

# 2. Add repository and key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# 3. Install and start Jenkins
sudo dnf install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

# 4. Open firewall
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

### Option 4: Windows

1. Download the latest official Windows installer (`.msi`) from [jenkins.io/download](https://www.jenkins.io/download/).
2. Run the installer and configure:
   - **Service Logon Credentials:** Specify Local System or a dedicated domain service account.
   - **Port Selection:** Verify port `8080` availability.
   - **Java Home Directory:** Select installed JDK 17 / JDK 21 directory.
3. Access Jenkins at `http://localhost:8080`.

---

## 🧙 Initial Setup Wizard

Once Jenkins is running, navigate to `http://<YOUR_SERVER_IP>:8080` in your web browser.

### Step 1: Unlock Jenkins
Retrieve the initial administrator password:

- **Linux / Bare Metal:**
  ```bash
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```
- **Docker:**
  ```bash
  docker exec -it jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
  ```

Paste the 32-character alphanumeric key into the unlock prompt.

### Step 2: Install Plugins
- Choose **"Install suggested plugins"** for standard CI/CD workflows (Git, Pipeline, Ant, Gradle, Mailer, etc.).

### Step 3: Create First Admin User
- Enter username, password, full name, and administrator email address.
- *(Optional)* You can choose "Continue as admin", but creating a custom administrator account is strongly recommended.

### Step 4: Configure Instance URL
- Set the Jenkins URL (e.g., `https://ci.example.com` or `http://192.168.1.100:8080`).

---

## ⚙️ Post-Installation & Service Management

### Managing the Systemd Service
```bash
# Check status
sudo systemctl status jenkins

# Start service
sudo systemctl start jenkins

# Stop service
sudo systemctl stop jenkins

# Restart service
sudo systemctl restart jenkins
```

### Changing Default Port (8080)
If port `8080` conflicts with another application:

1. Edit Jenkins systemd override configuration:
   ```bash
   sudo systemctl edit jenkins
   ```
2. Add the following override block:
   ```ini
   [Service]
   Environment="JENKINS_PORT=8081"
   ```
3. Restart Jenkins:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart jenkins
   ```

### Configuring Nginx Reverse Proxy & SSL
Protect Jenkins traffic by routing through Nginx with SSL (Let's Encrypt / Certbot):

```nginx
server {
    listen 80;
    server_name ci.yourdomain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ci.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ci.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ci.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_max_temp_file_size 0;
        client_max_body_size 10m;
        client_body_buffer_size 128k;
        proxy_connect_timeout 90;
        proxy_read_timeout 90;
    }
}
```

---

## 🧩 Essential Plugins & Tools

To configure plugins, go to **Manage Jenkins** > **Plugins** > **Available plugins**:

| Plugin Name | Category | Purpose |
| :--- | :--- | :--- |
| **Pipeline: Stage View** | CI/CD | Visual pipeline execution tracking |
| **Blue Ocean** | UI / UX | Modern, intuitive user experience for pipelines |
| **Git & GitHub Integration** | SCM | Webhook automation and branch builds |
| **Credentials Binding** | Security | Mask API keys, passwords, and SSH keys in logs |
| **Docker Pipeline** | Containers | Run pipeline builds inside Docker containers |
| **SonarQube Scanner** | Code Quality | Automated static code analysis |
| **Slack / Discord Notification** | ChatOps | Send build status alerts to team channels |

---

## 🏗️ Creating Your First Declarative Pipeline

1. In Jenkins dashboard, click **New Item**.
2. Enter item name `sample-pipeline` and select **Pipeline** > Click **OK**.
3. Scroll down to the **Pipeline** section and select **Pipeline script**.
4. Paste the following declarative pipeline:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code repository...'
            }
        }
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'java -version || true'
            }
        }
        stage('Test') {
            steps {
                echo 'Running unit and integration tests...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying artifact to staging environment...'
            }
        }
    }

    post {
        always {
            echo 'Build workflow complete.'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Alerting team.'
        }
    }
}
```
5. Click **Save** and select **Build Now** to verify execution.

---

## 🛠️ Troubleshooting & FAQs

### 1. `java.lang.UnsupportedClassVersionError` or Jenkins fails to start
- **Cause:** Jenkins 2.357+ requires Java 17 or Java 21. Java 8 and 11 will prevent the service from launching.
- **Fix:** Install OpenJDK 17 (`sudo apt install openjdk-17-jre`) and set default Java using `sudo update-alternatives --config java`.

### 2. Port 8080 Already in Use
- **Check process holding the port:**
  ```bash
  sudo lsof -i :8080
  # or
  sudo ss -tulpn | grep 8080
  ```
- **Fix:** Terminate conflicting process or change Jenkins port as shown in [Changing Default Port](#changing-default-port-8080).

### 3. Docker: `permission denied while trying to connect to the Docker daemon socket`
- **Cause:** The Jenkins container user does not have permission on mounted `/var/run/docker.sock`.
- **Fix:**
  ```bash
  # Inside host machine:
  sudo chmod 666 /var/run/docker.sock
  # Or grant docker group permissions:
  sudo usermod -aG docker jenkins
  ```

### 4. Viewing Jenkins Log Files
- **Linux (systemd):** `sudo journalctl -u jenkins -f`
- **Log file location:** `/var/log/jenkins/jenkins.log`
- **Docker logs:** `docker logs -f jenkins-server`

---

## 📂 Repository Structure & Roadmap

```text
.
├── README.md               # Main setup guide & overview
├── LICENSE                 # License information
└── docs/                   # (Planned) Deep-dive modular guides
    ├── 01-prerequisites.md # Hardware & network planning
    ├── 02-linux-setup.md   # Step-by-step Debian/Ubuntu/RHEL guides
    ├── 03-docker-setup.md  # Docker & Docker Compose setup
    ├── 04-security.md      # RBAC, LDAP, Reverse Proxy, SSL
    └── 05-pipelines.md     # CI/CD pipeline examples & Jenkinsfiles
```

---

## 📄 License

This guide is open-source and released under the [MIT License](LICENSE). Contributions, issues, and feature requests are welcome!
