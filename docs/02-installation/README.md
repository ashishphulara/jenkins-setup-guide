# Step 2: Jenkins Installation Guides 💻

Choose your target operating system or deployment architecture below:

---

## Installation Options

| Environment | Guide | Recommended Use Case |
| :--- | :--- | :--- |
| **Ubuntu / Debian** | [ubuntu-debian.md](./ubuntu-debian.md) | Dedicated bare-metal servers or cloud VMs running Ubuntu (20.04, 22.04, 24.04) or Debian. |
| **Docker & Compose** | [docker.md](./docker.md) | Containerized setups, Kubernetes, cloud platforms, fast local test setups, and reproducible deployments. |
| **RHEL / CentOS / Rocky** | [rhel-centos.md](./rhel-centos.md) | Enterprise Linux distributions (Red Hat, Rocky Linux, AlmaLinux, Amazon Linux 2023). |
| **Windows** | [windows.md](./windows.md) | Windows Server or local Windows development environments using the native MSI installer. |

---

## Quick Comparison: Native Package vs Docker

| Aspect | Native Linux (APT/RPM) | Docker Container |
| :--- | :--- | :--- |
| **Installation Complexity** | Low (System package manager) | Very Low (`docker run` / `docker compose`) |
| **Upgrade Process** | `apt update && apt upgrade jenkins` | `docker compose pull && docker compose up -d` |
| **Java Management** | Managed by host OS | Bundled inside container image |
| **Process Isolation** | Shared host environment | Sandboxed inside container |
| **Docker-in-Docker Builds** | Native Docker CLI on host | Requires Docker socket mounting |
| **Recommended For** | Dedicated VM controller | Microservices & container-native teams |

---

## Next Step

After completing installation using any method above, proceed to:
👉 [Step 3: Initial Setup & Unlock Wizard](../03-initial-setup/README.md)
