# Step 8: Troubleshooting & Frequently Asked Questions 🛠️

Comprehensive troubleshooting guide for common errors encountered when installing, starting, and running Jenkins.

---

## 1. Where to Find Jenkins Logs

When diagnosing issues, always check the Jenkins system logs first:

| Platform | Primary Log Command / Location |
| :--- | :--- |
| **Linux (Systemd)** | `sudo journalctl -u jenkins -f --no-tail` |
| **Linux Log File** | `/var/log/jenkins/jenkins.log` |
| **Docker** | `docker logs -f jenkins-server` |
| **Windows Service** | `C:\Program Files\Jenkins\jenkins.out.log` & `jenkins.err.log` |
| **Jenkins Web UI** | Navigate to **Manage Jenkins** > **System Log** |

---

## 2. Common Issues & Solutions

### Issue 1: `java.lang.UnsupportedClassVersionError` or Jenkins fails to start
- **Symptom:** The service exits immediately with code `1/FAILURE` or class version mismatch error in `journalctl`.
- **Cause:** Jenkins 2.357+ requires **Java 17 or Java 21**. Running Jenkins on Java 8 or Java 11 causes this failure.
- **Solution:**
  1. Install OpenJDK 17:
     ```bash
     sudo apt install -y openjdk-17-jre # Ubuntu/Debian
     sudo dnf install -y java-17-openjdk # RHEL/CentOS
     ```
  2. Select Java 17 as the system default:
     ```bash
     sudo update-alternatives --config java
     ```
  3. Restart Jenkins:
     ```bash
     sudo systemctl restart jenkins
     ```

---

### Issue 2: `Address already in use: bind` (Port 8080 Conflict)
- **Symptom:** Jenkins will not start; logs indicate port 8080 is already occupied.
- **Diagnosis:**
  ```bash
  sudo lsof -i :8080
  # or
  sudo ss -tulpn | grep 8080
  ```
- **Solution:**
  Change Jenkins port by creating a systemd override:
  ```bash
  sudo systemctl edit jenkins
  ```
  Add:
  ```ini
  [Service]
  Environment="JENKINS_PORT=8085"
  ```
  Reload and restart:
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart jenkins
  ```

---

### Issue 3: Docker: `permission denied while trying to connect to the Docker daemon socket`
- **Symptom:** Pipelines attempting to run `docker build` or `docker run` inside Jenkins fail with permission errors accessing `/var/run/docker.sock`.
- **Cause:** The default `jenkins` user in the container (UID 1000) does not belong to the host machine's `docker` group.
- **Solution (Host machine):**
  ```bash
  # Check host docker group GID
  getent group docker

  # Option A: Add the jenkins user to host docker group
  sudo usermod -aG docker jenkins

  # Option B: Set permissions on socket (dev/eval environments)
  sudo chmod 666 /var/run/docker.sock
  ```

---

### Issue 4: "It appears that your reverse proxy set up is broken"
- **Symptom:** Warning appears in the Jenkins administrative monitor after setting up Nginx, Apache, or AWS ALB.
- **Cause:** The reverse proxy is either not setting the `X-Forwarded-Proto` header, or the configured **Jenkins URL** uses `http://` while the user is browsing via `https://`.
- **Solution:**
  1. Ensure your Nginx configuration contains:
     ```nginx
     proxy_set_header Host $host:$server_port;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
     proxy_set_header X-Forwarded-Port $server_port;
     ```
  2. In Jenkins, go to **Manage Jenkins** > **System** > verify **Jenkins URL** matches your domain (e.g. `https://ci.yourdomain.com/`).

---

### Issue 5: Jenkins Out of Memory (OOM) / Crashes during heavy builds
- **Symptom:** The Jenkins UI becomes sluggish, unresponsive, or the process is killed by Linux OOM killer (`dmesg | grep -i oom`).
- **Solution:**
  Increase JVM heap space in `systemctl edit jenkins`:
  ```ini
  [Service]
  Environment="JAVA_OPTS=-Xms2048m -Xmx4096m -XX:+UseG1GC"
  ```
  > [!TIP]
  > Offload build workloads to **distributed agents (executors on separate worker VMs/containers)** so the controller process only handles orchestration.

---

### Issue 6: Forgotten Admin Password
If locked out of Jenkins:
1. Stop the service:
   ```bash
   sudo systemctl stop jenkins
   ```
2. Edit `/var/lib/jenkins/config.xml`:
   Find `<useSecurity>true</useSecurity>` and change it to `<useSecurity>false</useSecurity>`.
3. Start Jenkins:
   ```bash
   sudo systemctl start jenkins
   ```
4. Access the Web UI (no authentication required), re-configure security under **Manage Jenkins** > **Security**, reset the password, and re-enable security.
