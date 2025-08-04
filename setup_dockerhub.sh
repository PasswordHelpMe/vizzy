#!/bin/bash

# Docker Hub Setup Script for Vizio TV API
# This script helps you publish your API to Docker Hub

set -e

echo "🐳 Docker Hub Setup for Vizio TV API"
echo "====================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Get Docker Hub username
read -p "Enter your Docker Hub username: " DOCKERHUB_USERNAME

if [ -z "$DOCKERHUB_USERNAME" ]; then
    echo "❌ Docker Hub username is required"
    exit 1
fi

echo "🔧 Building Docker image..."
docker build -t vizio-api .

echo "🏷️  Tagging image..."
docker tag vizio-api $DOCKERHUB_USERNAME/vizio-api:latest
docker tag vizio-api $DOCKERHUB_USERNAME/vizio-api:v1.0.0

echo "🔐 Logging into Docker Hub..."
echo "Please enter your Docker Hub password:"
docker login

echo "📤 Pushing to Docker Hub..."
docker push $DOCKERHUB_USERNAME/vizio-api:latest
docker push $DOCKERHUB_USERNAME/vizio-api:v1.0.0

echo ""
echo "🎉 Successfully published to Docker Hub!"
echo ""
echo "📋 Next steps:"
echo "1. Go to https://hub.docker.com/r/$DOCKERHUB_USERNAME/vizio-api"
echo "2. Update the repository description"
echo "3. Add usage instructions"
echo ""
echo "🔧 To test your published image:"
echo "docker run -p 8000:8000 \\"
echo "  -e VIZIO_IP=192.168.1.100 \\"
echo "  -e VIZIO_PORT=7345 \\"
echo "  -e VIZIO_AUTH_TOKEN=your_token \\"
echo "  $DOCKERHUB_USERNAME/vizio-api:latest"
echo ""
echo "📚 For automated publishing, see DOCKERHUB_SETUP.md" 