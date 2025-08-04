#!/bin/bash

# Test Docker Build Script
# This script tests the Docker build process locally

set -e

echo "🧪 Testing Docker Build for Vizio TV API"
echo "========================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Clean up any existing images
echo "🧹 Cleaning up existing images..."
docker rmi vizio-api:test 2>/dev/null || true

# Build the image
echo "🔧 Building Docker image..."
docker build -t vizio-api:test .

if [ $? -eq 0 ]; then
    echo "✅ Docker build successful!"
else
    echo "❌ Docker build failed!"
    exit 1
fi

# Test the image
echo "🧪 Testing the built image..."
docker run --rm -d --name test-vizio-api -p 8000:8000 vizio-api:test

# Wait for the API to start
echo "⏳ Waiting for API to start..."
sleep 15

# Test the health endpoint
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Image test successful!"
    echo ""
    echo "🎉 Docker build and test completed successfully!"
    echo ""
    echo "📋 The image is ready for deployment!"
else
    echo "❌ Image test failed. Checking logs..."
    docker logs test-vizio-api
    echo ""
    echo "🔧 Troubleshooting tips:"
    echo "1. Check if port 8000 is available"
    echo "2. Verify the API starts correctly"
    echo "3. Check the Docker logs above"
fi

# Clean up
docker stop test-vizio-api 2>/dev/null || true
docker rmi vizio-api:test 2>/dev/null || true

echo ""
echo "📚 Next steps:"
echo "- Commit and push changes to trigger GitHub Actions"
echo "- Or run: ./build-multiarch.sh for local multi-arch build" 