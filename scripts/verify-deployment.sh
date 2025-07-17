#!/bin/bash

echo "=== EC2 Deployment Verification Script ==="
echo ""

# Check if Docker is running
echo "1. Checking Docker status..."
if docker ps > /dev/null 2>&1; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is not running or not accessible"
    exit 1
fi

# Check if our container is running
echo ""
echo "2. Checking if gladiators-api container is running..."
if docker ps | grep -q "gladiators-api"; then
    echo "✅ gladiators-api container is running"
    docker ps | grep gladiators-api
else
    echo "❌ gladiators-api container is not running"
    echo "Recent containers:"
    docker ps -a | head -5
fi

# Check if port 3000 is accessible locally
echo ""
echo "3. Checking local accessibility..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Application is accessible locally on port 3000"
    curl -s http://localhost:3000/health | jq .
else
    echo "❌ Application is not accessible on localhost:3000"
fi

# Get public IP
echo ""
echo "4. Getting public IP address..."
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
if [ ! -z "$PUBLIC_IP" ]; then
    echo "✅ Public IP: $PUBLIC_IP"
    echo "🌐 Try accessing: http://$PUBLIC_IP:3000"
    echo "🔍 Health check: http://$PUBLIC_IP:3000/health"
else
    echo "❌ Could not retrieve public IP"
fi

# Check if port 3000 is listening
echo ""
echo "5. Checking port 3000 status..."
if netstat -tlnp | grep -q ":3000"; then
    echo "✅ Port 3000 is listening"
    netstat -tlnp | grep ":3000"
else
    echo "❌ Port 3000 is not listening"
fi

echo ""
echo "=== Verification Complete ==="
