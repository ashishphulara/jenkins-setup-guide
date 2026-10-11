# Step 6: Plugins & Global Tools Configuration 🧩

Plugins are the building blocks of Jenkins, extending its functionality for source control, build tools, containers, cloud agents, and notification integrations.

---

## 1. Managing Plugins via Web UI

1. Go to **Manage Jenkins** > **Plugins**.
2. **Installed plugins:** View, disable, or uninstall existing plugins.
3. **Available plugins:** Search for and install new plugins.
4. **Updates:** Check for and apply updates.
5. Check the box **"Restart Jenkins when installation is complete and no jobs are running"** if required.

---

## 2. Essential Recommended Plugins

| Category | Plugin ID | Purpose |
| :--- | :--- | :--- |
| **Pipeline** | `workflow-aggregator` | Complete suite for declarative & scripted pipelines |
| **Pipeline UI** | `blueocean` | Modern dashboard visualization for pipelines |
| **SCM** | `git` / `github` / `gitlab-plugin` | Clone code, trigger builds via webhooks, report status back |
| **Credentials** | `credentials-binding` | Injects secrets into pipeline builds and masks them in console logs |
| **Containers** | `docker-workflow` | Allows pipelines to use `agent { docker { ... } }` |
| **Security** | `role-strategy` | Role-based permission management for projects and users |
| **Code Quality** | `sonar` (SonarQube Scanner) | Run automated code quality & security vulnerability scans |
| **Artifacts** | `nexus-artifact-uploader` / `artifactory` | Publish packages to binary repositories |
| **ChatOps** | `slack` / `discord-notifier` | Post real-time build status updates to team communication channels |
| **Utilities** | `ws-cleanup` | Wipes workspace before or after builds to prevent disk leaks |

---

## 3. Automated Plugin Installation via Jenkins CLI

For automated or scripted setups, you can install plugins using the Jenkins CLI (`jenkins-cli.jar`):

```bash
# 1. Download CLI jar from your running Jenkins server
curl -sO http://localhost:8080/jnlpJars/jenkins-cli.jar

# 2. Install plugins from a list
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:<API_TOKEN_OR_PASSWORD> install-plugin git docker-workflow blueocean -restart
```

A sample list of recommended plugins is available in [plugins.txt](./plugins.txt).

---

## 4. Configuring Global Tools

Global Tools let Jenkins automatically download or use installed build tools like JDKs, Maven, NodeJS, and Docker.

Navigate to **Manage Jenkins** > **Tools**:

### A. JDK
- Click **Add JDK**.
- Name: `JDK-17`
- Either specify `JAVA_HOME` path (e.g., `/usr/lib/jvm/java-17-openjdk-amd64`) or check **Install automatically** from Adoptium.

### B. Git
- Name: `Default`
- Path to Git executable: `git` (or `/usr/bin/git`).

### C. Maven
- Name: `Maven-3.9`
- Check **Install automatically** > Select version (e.g. `3.9.6`).

### D. NodeJS
- Install the **NodeJS Plugin**.
- In **Tools** > **NodeJS**: Name `NodeJS-20`, check **Install automatically**, select version `20.x`.

### E. Docker
- Click **Add Docker**.
- Name: `Docker-Latest`.
- Installation method: Install automatically or provide path to host binary.

---

## 5. Next Step

Write and run your first CI/CD pipeline:
👉 [Step 7: Pipeline Examples & Jenkinsfiles](../07-pipeline-examples/README.md)
