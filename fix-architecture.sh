#!/bin/bash

# Quick Fix for Docker Architecture Issues
# This script helps resolve "no matching manifest" errors

set -e

echo "🔧 Quick Fix for Docker Architecture Issues"
echo "=========================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Check server architecture
ARCH=$(uname -m)
echo "🏗️  Server architecture: $ARCH"

case $ARCH in
    x86_64)
        PLATFORM="linux/amd64"
        echo "📋 Using platform: $PLATFORM"
        ;;
    aarch64)
        PLATFORM="linux/arm64"
        echo "📋 Using platform: $PLATFORM"
        ;;
    armv7l)
        PLATFORM="linux/arm/v7"
        echo "📋 Using platform: $PLATFORM"
        ;;
    *)
        echo "⚠️  Unknown architecture: $ARCH"
        echo "📋 Using default platform: linux/amd64"
        PLATFORM="linux/amd64"
        ;;
esac

echo ""
echo "🔧 Building image for your architecture..."

# Build for your specific architecture
docker build --platform $PLATFORM -t vizio-api .

echo ""
echo "✅ Image built successfully for $PLATFORM"
echo ""
echo "🧪 Testing the image..."

# Test the image
docker run --rm -d --name test-vizio-api -p 8000:8000 vizio-api

# Wait for the API to start
sleep 10

# Test the health endpoint
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Image works correctly!"
    echo ""
    echo "🎉 Your Vizio TV API is ready to use!"
    echo ""
    echo "📋 To run on your server:"
    echo "docker run -p 8000:8000 \\"
    echo "  -e VIZIO_IP=192.168.1.100 \\"
    echo "  -e VIZIO_PORT=7345 \\"
    echo "  -e VIZIO_AUTH_TOKEN=your_token \\"
    echo "  vizio-api"
else
    echo "❌ Image test failed. Check the logs:"
    docker logs test-vizio-api
fi

# Clean up
docker stop test-vizio-api 2>/dev/null || true

echo ""
echo "📚 For multi-architecture builds, see:"
echo "- build-multiarch.sh (local multi-arch build)"
echo "- DOCKER_TROUBLESHOOTING.md (detailed guide)" 