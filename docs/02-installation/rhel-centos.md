# Installing Jenkins on RHEL, CentOS, Rocky Linux & AlmaLinux 🎩

This guide covers installing Jenkins on Red Hat Enterprise Linux (RHEL 8/9), Rocky Linux, AlmaLinux, CentOS Stream, and Amazon Linux 2023.

---

## Step 1: Update System Packages

```bash
sudo dnf update -y
```

---

## Step 2: Install Java (OpenJDK 17)

Jenkins LTS requires Java 17 or Java 21:

```bash
sudo dnf install -y fontconfig java-17-openjdk-devel
```

Verify Java version:
```bash
java -version
```

---

## Step 3: Add Jenkins Official Red Hat Repository

Download the official Jenkins YUM repository definition and import the GPG signing key:

```bash
# Download repo file
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

---

## Step 4: Install Jenkins

Install the Jenkins package using `dnf` or `yum`:

```bash
sudo dnf install -y jenkins
```

---

## Step 5: Enable and Start the Jenkins Service

Reload systemd daemon, enable the service on boot, and start Jenkins:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins
```

Check status:
```bash
sudo systemctl status jenkins
```

---

## Step 6: Configure Firewall (firewalld)

If `firewalld` is active, permit incoming traffic on port `8080`:

```bash
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=50000/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
```

---

## Step 7: Next Step

Proceed to complete the initial setup:
👉 [Step 3: Initial Setup & Unlock Wizard](../03-initial-setup/README.md)
