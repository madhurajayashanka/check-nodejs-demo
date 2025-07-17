Here’s a **complete step-by-step summary** to set up a **Node.js app with CI/CD on AWS EC2 (Amazon Linux 2023), using Docker, Nginx, HTTPS via Certbot, and a custom domain**:

---

## ✅ **1. DNS & AWS EC2 Setup**

### ⚙️ **Domain**

* Go to **Route 53 → Hosted Zones**
* Add **A Record** for your subdomain:

  ```
  Name: gladiators-demo-dev.glitzandclicks.com
  Type: A
  Value: [Your EC2 Public IP]
  ```

### 🖥️ **Launch EC2 Instance**

* Use **Amazon Linux 2023**
* Allow these ports in **Security Group**:

  * TCP: `22` (SSH)
  * TCP: `80` (HTTP)
  * TCP: `443` (HTTPS)

---

## ✅ **2. Install Required Software on EC2**

### 📦 **Install Docker + Docker Compose Plugin**

```bash
sudo dnf install docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker  # Or reboot to apply group change
```

### 🧰 **Install git, nodejs, nginx, etc.**

```bash
sudo dnf install git nginx nodejs
```

---

## ✅ **3. Set Up Nginx Reverse Proxy**

### 🧾 Create Nginx Config File

```bash
sudo nano /etc/nginx/conf.d/gladiators.conf
```

```nginx
server {
    listen 80;
    server_name gladiators-demo-dev.glitzandclicks.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 🔄 Reload Nginx

```bash
sudo systemctl enable --now nginx
sudo nginx -t
sudo systemctl restart nginx
```

---

## ✅ **4. Enable HTTPS with Certbot**

```bash
sudo dnf install certbot python3-certbot-nginx
sudo certbot --nginx -d gladiators-demo-dev.glitzandclicks.com
```

---

## ✅ **5. GitHub Actions Self-Hosted Runner (CI/CD)**

### 🛠️ Install Runner on EC2

```bash
mkdir ~/actions-runner && cd ~/actions-runner
curl -o actions-runner-linux-x64-2.326.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.326.0/actions-runner-linux-x64-2.326.0.tar.gz
tar xzf actions-runner-linux-x64-2.326.0.tar.gz
./config.sh --url https://github.com/your-username/your-repo --token [GH_TOKEN]
./svc.sh install
sudo ./svc.sh start
```

> You may need `libicu`:

```bash
sudo dnf install libicu
```

---

## ✅ **6. Dockerize Your Node.js App**

### 📁 `Dockerfile`

```Dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "index.js"]
```

### 📁 `docker-compose.yml` (optional)

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
```

---

## ✅ **7. GitHub Actions Workflow**

### 📁 `.github/workflows/deploy.yml`

```yaml
name: Deploy to EC2

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: self-hosted

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Pull latest code
      run: git pull

    - name: Build Docker image
      run: docker build -t gladiators-api .

    - name: Stop old container
      run: docker stop gladiators-api || true && docker rm gladiators-api || true

    - name: Run new container
      run: docker run -d --name gladiators-api -p 3000:3000 gladiators-api
```

---

## ✅ **8. Troubleshooting Tips**

* ❌ `apt not found`: Use `dnf` on Amazon Linux 2023.
* ❌ `git: command not found`: `sudo dnf install git`
* ❌ `permission denied /var/run/docker.sock`: Ensure you're in the `docker` group.
* ❌ HTTPS not working: Check `certbot` logs & domain in Route 53.
* ❌ `Exec format error`: Download the correct runner binary for **Linux x64**.

---

Let me know if you want a full automated `user-data` script or Docker Compose version too.
