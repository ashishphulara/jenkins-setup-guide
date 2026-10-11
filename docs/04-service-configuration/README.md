# Step 4: Service Management & Configuration ⚙️

Learn how to control Jenkins as a background service, change the default HTTP port, adjust Java memory limits, and safely perform restarts.

---

## 1. Systemd Service Commands (Linux)

On modern Linux distributions, Jenkins is managed through `systemctl`:

```bash
# Check running status and uptime
sudo systemctl status jenkins

# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins immediately
sudo systemctl restart jenkins

# Enable Jenkins to start automatically on system reboot
sudo systemctl enable jenkins

# Disable Jenkins auto-start
sudo systemctl disable jenkins
```

---

## 2. Changing the Default HTTP Port

By default, Jenkins listens on port `8080`. If another service (such as Tomcat or another web server) is using this port, you can customize it.

### Modern Linux (Systemd Override - Recommended)
In modern Jenkins packages, configuration is managed through systemd overrides rather than editing `/etc/default/jenkins`.

1. Run the systemd override editor:
   ```bash
   sudo systemctl edit jenkins
   ```
2. In the editor window, enter the following lines:
   ```ini
   [Service]
   Environment="JENKINS_PORT=8081"
   ```
3. Save and exit (in nano: `Ctrl + O`, `Enter`, then `Ctrl + X`).
4. Reload the systemd daemon and restart Jenkins:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart jenkins
   ```
5. Verify Jenkins is listening on the new port:
   ```bash
   sudo ss -tulpn | grep 8081
   ```

### Docker
Change the host port mapping in your `docker run` command or `docker-compose.yml`:
```yaml
ports:
  - "8081:8080" # Map host port 8081 to container port 8080
```

---

## 3. Configuring JVM Heap Memory & Java Options

For production Jenkins controllers, configure minimum (`-Xms`) and maximum (`-Xmx`) JVM memory allocation to prevent Out Of Memory (OOM) crashes:

1. Open the systemd override editor:
   ```bash
   sudo systemctl edit jenkins
   ```
2. Add your Java memory parameters:
   ```ini
   [Service]
   Environment="JAVA_OPTS=-Djava.awt.headless=true -Xms1024m -Xmx4096m -XX:+UseG1GC"
   ```
3. Restart Jenkins:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart jenkins
   ```

---

## 4. Safely Restarting Jenkins

When builds are currently executing, an abrupt service restart will terminate running jobs. Use Jenkins' built-in safe restart endpoints via browser or CLI:

- **Safe Restart URL:** Navigate to `http://<JENKINS_URL>/safeRestart`
  - Jenkins will enter quiet mode, wait for existing builds to complete, and then restart.
- **Cancel Safe Restart:** `http://<JENKINS_URL>/cancelQuietDown`
- **Immediate Restart:** `http://<JENKINS_URL>/restart`
- **Safe Exit:** `http://<JENKINS_URL>/safeExit`

---

## 5. Next Step

Secure your Jenkins controller with Nginx and SSL:
👉 [Step 5: Security & Reverse Proxy](../05-security-and-proxy/README.md)
