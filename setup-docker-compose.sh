#!/bin/bash

echo "🚀 Setting up Vizio API with Docker Compose"
echo "============================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp env.docker.example .env
    echo "✅ Created .env file"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env file with your Vizio TV settings:"
    echo "   - VIZIO_IP: Your TV's IP address"
    echo "   - VIZIO_PORT: Your TV's port (usually 7345)"
    echo "   - VIZIO_AUTH_TOKEN: Your TV's auth token"
    echo ""
    echo "After editing .env, run: docker-compose up -d"
else
    echo "✅ .env file already exists"
fi

echo ""
echo "🔧 Docker Compose Configuration:"
echo "   - Container name: vizio-api"
echo "   - Port mapping: 30002:8000"
echo "   - Health check: /health endpoint"
echo "   - Logs: ./logs directory"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "🐳 Docker is running"
echo ""

# Check if image exists
if docker images | grep -q "passwordhelpme/vizio-api"; then
    echo "✅ Vizio API Docker image found"
else
    echo "⚠️  Vizio API Docker image not found locally"
    echo "   You can pull it with: docker pull passwordhelpme/vizio-api:latest"
    echo "   Or build it locally with: docker build -t passwordhelpme/vizio-api:latest ."
fi

echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your TV settings"
echo "2. Run: docker-compose up -d"
echo "3. Check logs: docker-compose logs -f"
echo "4. Test API: curl http://localhost:30002/health"
echo ""
echo "🌐 For nginx proxy manager:"
echo "   - Proxy host: localhost:30002"
echo "   - Use HTTPS and force SSL"
echo "   - Add custom location: /health" 