#!/usr/bin/env bash
# ==============================================================================
# Script: install-ubuntu.sh
# Description: Automated Jenkins LTS & OpenJDK 17 installation for Ubuntu/Debian
# ==============================================================================

set -euo pipefail

echo "=========================================="
echo " Starting Jenkins Installation on Ubuntu"
echo "=========================================="

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo or as root."
  exit 1
fi

echo "[1/5] Updating system packages..."
apt-get update -y
apt-get install -y fontconfig openjdk-17-jre curl gnupg

echo "[2/5] Verifying Java version..."
java -version

echo "[3/5] Adding Jenkins GPG keyring and repository..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "[4/5] Installing Jenkins..."
apt-get update -y
apt-get install -y jenkins

echo "[5/5] Enabling and starting Jenkins service..."
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Wait for unlock password to generate
echo "Waiting for Jenkins to initialize and generate admin password..."
sleep 15

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  echo "=========================================================="
  echo " Jenkins installed successfully!"
  echo " Access Web UI at: http://$(hostname -I | awk '{print $1}'):8080"
  echo " Initial Admin Password:"
  cat /var/lib/jenkins/secrets/initialAdminPassword
  echo "=========================================================="
else
  echo "Jenkins service started. Check status with: sudo systemctl status jenkins"
fi
