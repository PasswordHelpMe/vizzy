#!/bin/bash

# Multi-Architecture Docker Build Script for Vizio TV API
# This script builds Docker images for multiple platforms

set -e

echo "🐳 Multi-Architecture Docker Build for Vizio TV API"
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Buildx is available
if ! docker buildx version > /dev/null 2>&1; then
    echo "❌ Docker Buildx is not available. Please enable Docker Buildx."
    exit 1
fi

echo "✅ Docker Buildx is available"

# Get Docker Hub username
read -p "Enter your Docker Hub username: " DOCKERHUB_USERNAME

if [ -z "$DOCKERHUB_USERNAME" ]; then
    echo "❌ Docker Hub username is required"
    exit 1
fi

# Get version tag
read -p "Enter version tag (e.g., v1.0.0): " VERSION_TAG

if [ -z "$VERSION_TAG" ]; then
    VERSION_TAG="latest"
fi

echo "🔧 Building multi-architecture Docker image..."
echo "Platforms: linux/amd64, linux/arm64, linux/arm/v7"

# Create and use a new builder instance
docker buildx create --name multiarch-builder --use || true

# Build and push for multiple architectures
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    --tag $DOCKERHUB_USERNAME/vizio-api:$VERSION_TAG \
    --tag $DOCKERHUB_USERNAME/vizio-api:latest \
    --push \
    .

echo ""
echo "🎉 Successfully built and pushed multi-architecture image!"
echo ""
echo "📋 Image details:"
echo "Repository: $DOCKERHUB_USERNAME/vizio-api"
echo "Tags: $VERSION_TAG, latest"
echo "Architectures: linux/amd64, linux/arm64, linux/arm/v7"
echo ""
echo "🔧 To test on your server:"
echo "docker run -p 8000:8000 \\"
echo "  -e VIZIO_IP=192.168.1.100 \\"
echo "  -e VIZIO_PORT=7345 \\"
echo "  -e VIZIO_AUTH_TOKEN=your_token \\"
echo "  $DOCKERHUB_USERNAME/vizio-api:$VERSION_TAG"
echo ""
echo "📚 The image will automatically work on:"
echo "- x86_64 servers (linux/amd64)"
echo "- ARM64 servers (linux/arm64)"
echo "- ARM v7 servers (linux/arm/v7)" 