# Installing Jenkins on Windows 🪟

This guide explains how to install and run Jenkins on Windows Server or Windows 10/11 using the official Windows MSI installer or portable WAR file.

---

## Prerequisites

1. **Java Runtime:** Ensure OpenJDK 17 or 21 (x64) is installed.
   - Recommended: [Eclipse Temurin OpenJDK 17](https://adoptium.net/temurin/releases/?version=17)
2. **Environment Variables:**
   - Verify `JAVA_HOME` points to your JDK directory (e.g. `C:\Program Files\Eclipse Adoptium\jdk-17.x.x`).
   - Ensure `%JAVA_HOME%\bin` is added to your `Path` variable.
   - Open PowerShell and verify:
     ```powershell
     java -version
     ```

---

## Method 1: Windows MSI Installer (Recommended)

1. Download the Windows Installer package (`jenkins.msi`) from the official download portal:
   👉 [https://www.jenkins.io/download/](https://www.jenkins.io/download/)
2. Double-click the downloaded `.msi` file to run the setup wizard.
3. Configure the setup options:
   - **Installation Directory:** Default is `C:\Program Files\Jenkins\`.
   - **Service Logon Credentials:**
     - Select **Run service as LocalSystem** (for local workstations), OR
     - Provide dedicated Windows domain service credentials (for production enterprise servers).
   - **Port Selection:** Default is `8080`. Click **Test Port** to verify port availability.
   - **Java Home Directory:** Browse and select your JDK 17 folder.
4. Click **Install**.
5. Once complete, Jenkins runs as a Windows Service named `jenkins`.

### Managing the Windows Service (PowerShell as Administrator):
```powershell
# Check status
Get-Service -Name jenkins

# Stop Jenkins
Stop-Service -Name jenkins

# Start Jenkins
Start-Service -Name jenkins

# Restart Jenkins
Restart-Service -Name jenkins
```

---

## Method 2: Running via Standalone WAR File

For rapid local testing without installing a Windows service:

1. Download `jenkins.war` from [jenkins.io/download](https://www.jenkins.io/download/).
2. Run in PowerShell:
   ```powershell
   java -jar jenkins.war --httpPort=8080
   ```
3. Keep the console window open. Press `Ctrl + C` to shut down Jenkins.

---

## Step 3: Next Step

Open your browser to `http://localhost:8080` and unlock Jenkins:
👉 [Step 3: Initial Setup & Unlock Wizard](../03-initial-setup/README.md)
