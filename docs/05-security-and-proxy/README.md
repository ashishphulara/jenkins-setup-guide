# Step 5: Security Hardening & Reverse Proxy 🔒

Production Jenkins servers should never be exposed directly to the public internet on unencrypted HTTP port 8080. This guide covers setting up an Nginx reverse proxy with SSL (Let's Encrypt / Certbot), configuring Role-Based Access Control (RBAC), and securing credentials.

---

## 1. Setting up Nginx Reverse Proxy with HTTPS

A reverse proxy terminates TLS/SSL, manages certificates, buffers traffic, and offloads encryption overhead from the Jenkins Java process.

### Step 1: Install Nginx and Certbot
```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

### Step 2: Configure Nginx Virtual Host
Create `/etc/nginx/sites-available/jenkins.conf`:

```nginx
upstream jenkins_server {
    server 127.0.0.1:8080 fail_timeout=0;
}

server {
    listen 80;
    server_name ci.yourdomain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ci.yourdomain.com;

    # SSL certificates (filled automatically by certbot or provide your own)
    ssl_certificate /etc/letsencrypt/live/ci.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ci.yourdomain.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://jenkins_server;
        proxy_redirect default;
        proxy_http_version 1.1;

        # Essential headers for Jenkins reverse proxy support
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;

        # WebSocket support for CLI and Blue Ocean
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Buffer settings
        proxy_max_temp_file_size 0;
        client_max_body_size 100m;
        client_body_buffer_size 128k;
        proxy_connect_timeout 90;
        proxy_send_timeout 90;
        proxy_read_timeout 90;
    }
}
```

Enable the configuration and reload Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/jenkins.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 3: Issue Free SSL Certificate with Let's Encrypt
```bash
sudo certbot --nginx -d ci.yourdomain.com
```

---

## 2. Jenkins URL & Reverse Proxy Header Verification

1. Go to **Manage Jenkins** > **System**.
2. Find **Jenkins URL** and ensure it matches the full HTTPS domain:
   `https://ci.yourdomain.com/`
3. Click **Save**.

If Jenkins detects a mismatch or missing proxy headers, it displays a warning in **Manage Jenkins**: *"It appears that your reverse proxy set up is broken"*. The headers included in the Nginx config above prevent this issue.

---

## 3. Role-Based Access Control (RBAC)

By default, any user with an account might have broad permissions. Configure granular permissions using the **Role-based Authorization Strategy** plugin.

1. Navigate to **Manage Jenkins** > **Plugins** > **Available plugins**.
2. Search for `Role-based Authorization Strategy` and click **Install**.
3. Go to **Manage Jenkins** > **Security**.
4. In the **Authorization** section, choose **Role-Based Strategy** and save.
5. Go to **Manage Jenkins** > **Manage and Assign Roles**:
   - **Manage Roles:**
     - `admin`: Full administrative access.
     - `developer`: Read access, Build triggers, Workspace access, Cancel builds.
     - `viewer`: Read-only access to specific jobs.
   - **Assign Roles:** Map user accounts or LDAP/SSO groups to roles.

---

## 4. Securing Jenkins Credentials

Never hardcode credentials, SSH keys, or tokens in `Jenkinsfile` or repository code.

1. Go to **Manage Jenkins** > **Credentials** > **System** > **Global credentials**.
2. Click **Add Credentials**:
   - **Kind:** Secret text, Username with password, SSH Username with private key, or Secret file.
   - **ID:** Give a descriptive ID (e.g., `github-token`, `aws-credentials`, `docker-registry-key`).
3. In your pipelines, reference the credentials securely using `withCredentials` or declarative `credentials()` wrappers so they are automatically masked in build logs.

---

## 5. Next Step

Equip Jenkins with recommended plugins and global tools:
👉 [Step 6: Plugins & Tools Configuration](../06-plugins-and-tools/README.md)
