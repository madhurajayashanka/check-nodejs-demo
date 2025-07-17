# EC2 Setup Guide for Public Access

## 1. Security Group Configuration

### Required Inbound Rules:

- **Type**: Custom TCP
- **Port**: 3000
- **Source**: 0.0.0.0/0 (or your specific IP range)
- **Description**: Node.js Application

### To check/configure via AWS Console:

1. Go to EC2 Console → Security Groups
2. Find your EC2 instance's security group
3. Edit Inbound Rules
4. Add rule: TCP, Port 3000, Source 0.0.0.0/0

### To check via AWS CLI:

```bash
aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx
```

## 2. EC2 Instance Configuration

### Check if your app is running:

```bash
sudo docker ps
curl http://localhost:3000/health
```

### Check if port 3000 is accessible:

```bash
sudo netstat -tlnp | grep :3000
```

## 3. Access Your Application

Once configured, access via:

- **Public IP**: `http://YOUR-EC2-PUBLIC-IP:3000`
- **Public DNS**: `http://YOUR-EC2-PUBLIC-DNS:3000`

### Find your EC2 public details:

```bash
# Get public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Get public DNS
curl http://169.254.169.254/latest/meta-data/public-hostname
```

## 4. Optional: Set up a domain name

For production, consider:

- Using Route 53 or your domain provider
- Setting up an Application Load Balancer
- Using HTTPS with SSL certificates
