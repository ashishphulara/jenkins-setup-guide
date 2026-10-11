# Step 1: Jenkins Prerequisites & System Preparation 📋

Before installing Jenkins, verify that your host system satisfies the necessary hardware, runtime, network, and security prerequisites.

---

## 1. Hardware Requirements

Jenkins hardware requirements vary based on the number of concurrent jobs and build agents.

| Environment Size | Concurrent Builds | Recommended CPU | Recommended RAM | Recommended Disk |
| :--- | :--- | :--- | :--- | :--- |
| **Evaluation / Learning** | 1 - 2 | 1 - 2 Cores | 2 GB | 20 GB SSD |
| **Small Team** | 3 - 5 | 2 - 4 Cores | 4 - 8 GB | 50 - 100 GB SSD |
| **Medium / Enterprise** | 10+ (Controller only) | 4 - 8 Cores | 16 - 32 GB | 200+ GB Fast NVMe |

> [!TIP]
> In production environments, run builds on **Jenkins Distributed Agents (Nodes)** rather than executing build jobs directly on the Controller (Master). This keeps the controller stable and responsive.

---

## 2. Java Runtime (JDK / JRE)

Jenkins is a Java application. Current Jenkins LTS releases **require Java 17 or Java 21**.

> [!WARNING]
> Java 8 and Java 11 are **no longer supported** in current versions of Jenkins. Attempting to start Jenkins with Java 8 or 11 will result in a startup failure (`java.lang.UnsupportedClassVersionError`).

### Checking Java Version
Run the following command on your machine:
```bash
java -version
```

### Installing OpenJDK 17

#### On Ubuntu / Debian:
```bash
sudo apt update
sudo apt install -y fontconfig openjdk-17-jdk
java -version
```

#### On RHEL / CentOS / Rocky Linux / AlmaLinux:
```bash
sudo dnf install -y fontconfig java-17-openjdk-devel
java -version
```

#### On macOS (Homebrew):
```bash
brew install openjdk@17
```

#### On Windows:
Download and install Microsoft OpenJDK 17 or Eclipse Temurin 17 from:
- [Eclipse Temurin OpenJDK Releases](https://adoptium.net/temurin/releases/?version=17)

Make sure `JAVA_HOME` is added to your System Environment Variables and `%JAVA_HOME%\bin` is added to your `PATH`.

---

## 3. Network & Port Requirements

Make sure the following inbound and outbound network ports are open on your machine or firewall:

| Port | Protocol | Direction | Purpose |
| :--- | :--- | :--- | :--- |
| **8080** | TCP / HTTP | Inbound | Default Jenkins Web UI & REST API |
| **8443 / 443** | TCP / HTTPS | Inbound | Secure Web UI (when using SSL or Reverse Proxy) |
| **50000** | TCP | Inbound | Default JNLP / Inbound Agent connection port |
| **22** | TCP / SSH | Outbound | Connecting to SSH build agents or Git repositories |
| **443** | TCP / HTTPS | Outbound | Downloading plugins, interacting with GitHub/GitLab, cloud APIs |

### Firewall Configuration

#### Ubuntu UFW:
```bash
sudo ufw allow 8080/tcp comment 'Jenkins Web UI'
sudo ufw allow 50000/tcp comment 'Jenkins JNLP Agent Port'
sudo ufw reload
sudo ufw status
```

#### RHEL / CentOS firewalld:
```bash
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=50000/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
```

---

## 4. System User & Storage Permissions

If installing natively on Linux, Jenkins will automatically create a dedicated system user: `jenkins`.

Verify or set directory ownership for Jenkins Home:
```bash
# Default Jenkins home directory
ls -ld /var/lib/jenkins

# If manually creating or moving the directory:
sudo mkdir -p /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chmod -R 775 /var/lib/jenkins
```

---

## 5. Next Step

Once prerequisites are satisfied, proceed to installation:
👉 [Step 2: Installation Methods](../02-installation/README.md)
