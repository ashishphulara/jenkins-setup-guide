# Step 7: Pipeline Examples & Jenkinsfiles 🏗️

Jenkins Pipelines use Groovy syntax to model your delivery pipeline as code. Pipelines can be checked into source control directly as a `Jenkinsfile`.

---

## 1. Declarative vs Scripted Pipelines

| Feature | Declarative Pipeline (Recommended) | Scripted Pipeline |
| :--- | :--- | :--- |
| **Syntax** | Strict, structured, schema-like | Free-form Groovy programming |
| **Ease of Learning** | Very easy; clear stages and steps | Requires Groovy scripting expertise |
| **Error Checking** | Validated before execution | Errors caught during runtime |
| **Blue Ocean Support** | Full visual editing and rendering | Limited visualization |

We strongly recommend **Declarative Pipelines** for all new projects.

---

## 2. Declarative Pipeline Anatomy

```groovy
pipeline {
    agent any              // Specifies where pipeline executes

    environment {          // Environment variables
        APP_NAME = 'my-app'
        APP_ENV  = 'production'
    }

    stages {               // Main execution sequence
        stage('Build') {
            steps {
                echo "Building ${APP_NAME}..."
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }

    post {                 // Actions run after completion
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed! Alerting team...'
        }
    }
}
```

---

## 3. Included Templates in this Repository

- **[Jenkinsfile.simple](./Jenkinsfile.simple)**: A standard multi-stage build, test, and deploy pipeline with parameter triggers and error handlers.
- **[Jenkinsfile.docker](./Jenkinsfile.docker)**: A containerized pipeline executing inside a Docker container (Node.js/Maven) and pushing a Docker image to a registry.

---

## 4. Setting Up Webhook Automation with GitHub

To trigger automatic builds when developers push code:

1. **In GitHub Repository:**
   - Go to **Settings** > **Webhooks** > **Add webhook**.
   - **Payload URL:** `https://ci.yourdomain.com/github-webhook/` (trailing slash is mandatory).
   - **Content type:** `application/json`.
   - **Secret:** *(Optional secret token)*.
   - **Which events:** Select *Just the push event* or *Let me select individual events (Pushes, Pull requests)*.
2. **In Jenkins Pipeline Job:**
   - Check the box: **GitHub hook trigger for GITScm polling**.
   - In the pipeline definition, choose **Pipeline script from SCM** > select Git > enter repository URL and credentials.

---

## 5. Next Step

Solve common Jenkins errors and diagnose issues:
👉 [Step 8: Troubleshooting & FAQs](../08-troubleshooting/README.md)
