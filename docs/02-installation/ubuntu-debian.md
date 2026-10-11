# Installing Jenkins on Ubuntu & Debian 🐧

This guide walks through setting up the official Jenkins LTS repository and installing Jenkins as a systemd service on Ubuntu (20.04 LTS, 22.04 LTS, 24.04 LTS) and Debian (11, 12).

---

## Step 1: Update System Packages

Ensure system package indices and installed software are up to date:
```bash
sudo apt update && sudo apt upgrade -y
```

---

## Step 2: Install Java (OpenJDK 17)

Jenkins requires Java 17 or Java 21:
```bash
sudo apt install -y fontconfig openjdk-17-jre
```

Verify the installation:
```bash
java -version
```
Expected output:
```text
openjdk version "17.0.x" ...
OpenJDK Runtime Environment ...
```

---

## Step 3: Add Jenkins GPG Key & Official Repository

The official Jenkins repository signs packages with a GPG key. Add the key and the package repository source:

```bash
# Ensure keyrings directory exists
sudo mkdir -p /etc/apt/keyrings

# Download and save the Jenkins LTS keyring
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

# Add the debian-stable repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

---

## Step 4: Install Jenkins

Update the package cache to detect packages from the newly added Jenkins repository, then install Jenkins:

```bash
sudo apt update
sudo apt install -y jenkins
```

---

## Step 5: Enable and Start the Jenkins Service

Jenkins is configured as a systemd service called `jenkins`.

```bash
# Enable Jenkins to start automatically on system reboot
sudo systemctl enable jenkins

# Start the Jenkins service
sudo systemctl start jenkins

# Check the service status
sudo systemctl status jenkins
```

You should see an active status output indicating:
```text
● jenkins.service - Jenkins Continuous Integration Server
     Loaded: loaded (/lib/systemd/system/jenkins.service; enabled; ...)
     Active: active (running) ...
```

---

## Step 6: Configure Firewall (UFW)

If UFW (Uncomplicated Firewall) is enabled, open inbound traffic on port `8080`:

```bash
sudo ufw allow 8080/tcp comment 'Jenkins Web UI'
sudo ufw reload
sudo ufw status
```

---

## Step 7: Next Step

Jenkins is now running! Proceed to:
👉 [Step 3: Initial Setup & Unlock Wizard](../03-initial-setup/README.md)
