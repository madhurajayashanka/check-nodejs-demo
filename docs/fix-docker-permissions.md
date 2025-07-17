# Fix Docker Permission Issues for GitHub Actions Runner

## The Problem

GitHub Actions runner can't access Docker daemon due to permission issues.

## Solution Steps

### 1. SSH into your EC2 instance

### 2. Check current user and runner user

```bash
# Check who is running the GitHub Actions runner
ps aux | grep runner
# or
ps aux | grep actions-runner
```

### 3. Add the runner user to docker group

```bash
# If the runner user is 'ubuntu' (common on Ubuntu EC2 instances)
sudo usermod -aG docker ubuntu

# If the runner user is 'ec2-user' (common on Amazon Linux)
sudo usermod -aG docker ec2-user

# If you have a specific 'runner' user
sudo usermod -aG docker runner

# Check what user is running the runner service
sudo systemctl status actions.runner.* | grep User
```

### 4. Restart the runner service

```bash
# Find your runner service name
sudo systemctl list-units --type=service | grep runner

# Restart the service (replace with your actual service name)
sudo systemctl restart actions.runner.madhurajayashanka-check-nodejs-demo.*

# Or if it's a different service name:
sudo systemctl restart github-actions-runner
```

### 5. Alternative: Restart the runner manually

If you can't find the service, you can restart the runner manually:

```bash
# Navigate to your runner directory (usually in home directory)
cd ~/actions-runner

# Stop the runner
sudo ./svc.sh stop

# Start the runner
sudo ./svc.sh start
```

### 6. Verify Docker access

```bash
# Test Docker access with the runner user
sudo -u ubuntu docker ps
# or
sudo -u ec2-user docker ps
# or
sudo -u runner docker ps
```

### 7. Test with your verification script

```bash
# Make sure the script is executable
chmod +x scripts/verify-deployment.sh

# Run the verification
./scripts/verify-deployment.sh
```

## Quick Commands to Run on EC2

```bash
# Add ubuntu user to docker group (most common)
sudo usermod -aG docker ubuntu

# Restart Docker service
sudo systemctl restart docker

# Find and restart runner service
sudo systemctl restart actions.runner.*

# Test Docker access
docker ps
```

## If the issue persists

### Option 1: Run Docker commands with sudo

Update your GitHub Actions workflow to use sudo for Docker commands.

### Option 2: Check Docker socket permissions

```bash
# Check Docker socket permissions
ls -la /var/run/docker.sock

# Make sure Docker group exists and has proper permissions
getent group docker
```

### Option 3: Verify Docker is running

```bash
sudo systemctl status docker
sudo systemctl start docker
```
