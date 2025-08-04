# Docker Troubleshooting Guide

This guide helps resolve common Docker issues, especially architecture-related problems.

## Common Issues and Solutions

### 1. "no matching manifest for linux/amd64" Error

**Problem**: Your Docker image was built for a different architecture than your server.

**Solution**: Use multi-architecture builds.

#### Option A: Use Pre-built Multi-Arch Image
```bash
# Pull the multi-architecture image
docker pull YOUR_DOCKERHUB_USERNAME/vizio-api:latest

# Run on your server
docker run -p 8000:8000 \
  -e VIZIO_IP=192.168.1.100 \
  -e VIZIO_PORT=7345 \
  -e VIZIO_AUTH_TOKEN=your_token \
  YOUR_DOCKERHUB_USERNAME/vizio-api:latest
```

#### Option B: Build Multi-Arch Locally
```bash
# Enable Docker Buildx
docker buildx create --name multiarch-builder --use

# Build for multiple architectures
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  --tag vizio-api:latest \
  --load \
  .
```

### 2. Check Your Server Architecture

```bash
# Check your server's architecture
uname -m

# Common outputs:
# x86_64 = linux/amd64
# aarch64 = linux/arm64
# armv7l = linux/arm/v7
```

### 3. Docker Buildx Issues

**Problem**: Docker Buildx not available.

**Solution**: Enable Docker Buildx.

```bash
# Enable Docker Buildx
docker buildx install

# Verify it's working
docker buildx version
```

### 4. QEMU Emulation Issues

**Problem**: Cross-platform builds fail.

**Solution**: Install QEMU for emulation.

```bash
# On Ubuntu/Debian
sudo apt-get install qemu-user-static

# On macOS (with Homebrew)
brew install qemu

# On CentOS/RHEL
sudo yum install qemu-user-static
```

### 5. Memory Issues During Build

**Problem**: Build fails due to insufficient memory.

**Solution**: Increase Docker resources.

1. Open Docker Desktop
2. Go to Settings → Resources
3. Increase Memory limit (recommend 4GB+)
4. Apply & Restart

### 6. Network Issues During Build

**Problem**: Build fails due to network timeouts.

**Solution**: Use build cache and retry.

```bash
# Build with cache
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  --cache-from type=registry,ref=YOUR_DOCKERHUB_USERNAME/vizio-api:cache \
  --cache-to type=registry,ref=YOUR_DOCKERHUB_USERNAME/vizio-api:cache,mode=max \
  --tag YOUR_DOCKERHUB_USERNAME/vizio-api:latest \
  --push \
  .
```

## Quick Fixes

### For Immediate Use

1. **Use the Multi-Arch Build Script**:
```bash
./build-multiarch.sh
```

2. **Or Build Locally for Your Architecture**:
```bash
# Check your architecture
uname -m

# Build for your specific architecture
docker build --platform linux/$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') -t vizio-api .
```

### For Production Deployment

1. **Use the GitHub Actions Workflow**:
   - Push a tag: `git tag v1.0.0 && git push origin v1.0.0`
   - GitHub Actions will build multi-arch automatically

2. **Pull the Multi-Arch Image**:
```bash
docker pull YOUR_DOCKERHUB_USERNAME/vizio-api:latest
```

## Architecture Compatibility

| Server Architecture | Docker Platform | Common Systems |
|-------------------|----------------|----------------|
| x86_64 | linux/amd64 | Most servers, desktop PCs |
| aarch64 | linux/arm64 | Apple M1/M2, ARM servers |
| armv7l | linux/arm/v7 | Raspberry Pi, older ARM devices |

## Testing Your Image

```bash
# Test the image locally
docker run --rm -p 8000:8000 vizio-api

# Test with environment variables
docker run --rm -p 8000:8000 \
  -e VIZIO_IP=192.168.1.100 \
  -e VIZIO_PORT=7345 \
  -e VIZIO_AUTH_TOKEN=your_token \
  vizio-api

# Check if the API responds
curl http://localhost:8000/health
```

## Best Practices

1. **Always use multi-architecture builds** for distribution
2. **Test on target architecture** before deployment
3. **Use specific version tags** (not just `latest`)
4. **Monitor build logs** for architecture-specific issues
5. **Keep Docker and buildx updated**

## Getting Help

If you're still having issues:

1. Check the build logs for specific error messages
2. Verify your Docker and buildx versions
3. Test with a simpler Dockerfile first
4. Consider using the pre-built image from Docker Hub

Your Vizio TV API should now work on any Linux server architecture! 🐳 