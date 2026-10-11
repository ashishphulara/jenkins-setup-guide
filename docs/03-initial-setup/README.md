# Step 3: Initial Setup & Unlock Wizard 🧙

Once Jenkins starts, open your web browser and navigate to:
```text
http://<YOUR_SERVER_IP_OR_HOSTNAME>:8080
```
(Or `http://localhost:8080` if running locally).

---

## 1. Unlocking Jenkins

You will see an **"Unlock Jenkins"** screen requesting an Administrator password.

Retrieve the 32-character key from the server:

### On Linux (Ubuntu / Debian / RHEL / CentOS):
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### On Docker:
```bash
# Using container name
docker exec -it jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword

# Or check initial container startup logs:
docker logs jenkins-server | grep -A 3 "initialAdminPassword"
```

### On Windows:
Open PowerShell as Administrator:
```powershell
Get-Content "C:\Program Files\Jenkins\secrets\initialAdminPassword"
```

Copy the password, paste it into the **Administrator password** field in your browser, and click **Continue**.

---

## 2. Customize Jenkins (Plugins)

Jenkins will ask: **"Customize Jenkins"**.

You have two choices:
1. **Install suggested plugins (Recommended):** Automatically installs standard, battle-tested plugins including:
   - Git & GitHub integration
   - Pipeline suite & Stage View
   - Folders, Credentials, Workspace Cleanup
   - Email Extension & Mailer
   - Timestamper
2. **Select plugins to install:** Allows granular choice of plugins if you need an offline or minimal installation.

> [!TIP]
> Choose **"Install suggested plugins"**. You can install and remove additional plugins anytime later via **Manage Jenkins** > **Plugins**.

Wait for the installation progress bars to finish.

---

## 3. Create First Administrator User

Once plugins finish installing, Jenkins prompts you to create an administrator account:

- **Username:** e.g., `admin` or your personal username
- **Password:** A strong password
- **Confirm password:** Re-enter password
- **Full name:** Admin's full name
- **E-mail address:** Administrator notification email

> [!IMPORTANT]
> While there is an option to *"Skip and continue as admin"*, it is strongly discouraged for production. Always create a dedicated administrator user and store the credentials securely.

---

## 4. Instance Configuration (Jenkins URL)

Set the root URL that Jenkins will use for links in notifications, emails, and build webhooks:

- Example: `http://192.168.1.50:8080/`
- Example with domain / SSL: `https://ci.yourdomain.com/`

Click **Save and Finish**, then click **Start using Jenkins**.

---

## 5. Next Step

Now that Jenkins is up and running, let's configure service management, ports, and reverse proxies:
👉 [Step 4: Service Management & Configuration](../04-service-configuration/README.md)
