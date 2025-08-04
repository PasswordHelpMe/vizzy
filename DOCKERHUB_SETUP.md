# Docker Hub Publishing Guide

This guide will help you publish your Vizio TV API to Docker Hub.

## Prerequisites

1. **Docker Hub Account**: Sign up at [hub.docker.com](https://hub.docker.com)
2. **Docker Installed**: Make sure Docker is installed and running locally
3. **GitHub Repository**: Your code should be on GitHub (which you already have)

## Step 1: Prepare Your Docker Image

### 1.1 Test Your Docker Image Locally

First, make sure your Docker image works:

```bash
# Build the image
docker build -t vizio-api .

# Test the image locally
docker run --rm -p 8000:8000 vizio-api
```

### 1.2 Create a Docker Hub Repository

1. Go to [hub.docker.com](https://hub.docker.com) and sign in
2. Click "Create Repository"
3. Choose:
   - **Repository Name**: `vizio-api` (or your preferred name)
   - **Visibility**: Public (recommended) or Private
   - **Description**: "FastAPI-based REST API for controlling Vizio SmartCast TVs"
4. Click "Create"

## Step 2: Tag and Push Your Image

### 2.1 Login to Docker Hub

```bash
docker login
# Enter your Docker Hub username and password
```

### 2.2 Tag Your Image

Replace `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username:

```bash
# Tag the image with your Docker Hub username
docker tag vizio-api YOUR_DOCKERHUB_USERNAME/vizio-api:latest

# Tag with version number (optional but recommended)
docker tag vizio-api YOUR_DOCKERHUB_USERNAME/vizio-api:v1.0.0
```

### 2.3 Push to Docker Hub

```bash
# Push the latest tag
docker push YOUR_DOCKERHUB_USERNAME/vizio-api:latest

# Push the version tag
docker push YOUR_DOCKERHUB_USERNAME/vizio-api:v1.0.0
```

## Step 3: Automated Publishing with GitHub Actions

### 3.1 Create Docker Hub Access Token

1. Go to Docker Hub → Account Settings → Security
2. Click "New Access Token"
3. Name it: `github-actions-vizio-api`
4. Copy the token (you'll need it for GitHub)

### 3.2 Add Docker Hub Secrets to GitHub

1. Go to your GitHub repository
2. Click "Settings" → "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add these secrets:
   - **Name**: `DOCKERHUB_USERNAME`
   - **Value**: Your Docker Hub username
5. Add another secret:
   - **Name**: `DOCKERHUB_TOKEN`
   - **Value**: The access token you created

### 3.3 Create Docker Publishing Workflow

Create `.github/workflows/docker-publish.yml`:

```yaml
name: Docker Publish

on:
  push:
    tags: [ 'v*' ]
  workflow_dispatch:

jobs:
  docker-publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ secrets.DOCKERHUB_USERNAME }}/vizio-api
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}
          type=sha
    
    - name: Build and push Docker image
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
```

## Step 4: Create a Release

### 4.1 Create a Git Tag

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

### 4.2 Create GitHub Release

1. Go to your GitHub repository
2. Click "Releases" → "Create a new release"
3. Choose the tag: `v1.0.0`
4. Title: `v1.0.0 - Initial Release`
5. Description:
```
## 🎉 Initial Release

### Features
- FastAPI REST API for Vizio TV control
- Power, volume, input, and app control
- Docker support
- Environment variable configuration

### Usage
```bash
docker run -p 8000:8000 YOUR_DOCKERHUB_USERNAME/vizio-api:latest
```

### Environment Variables
- `VIZIO_IP`: Your TV's IP address
- `VIZIO_PORT`: TV port (default: 7345)
- `VIZIO_AUTH_TOKEN`: TV auth token
```

## Step 5: Update Documentation

### 5.1 Update README.md

Add Docker Hub usage instructions to your README:

```markdown
## Quick Start with Docker Hub

```bash
# Pull the image
docker pull YOUR_DOCKERHUB_USERNAME/vizio-api:latest

# Run with environment variables
docker run -p 8000:8000 \
  -e VIZIO_IP=192.168.1.100 \
  -e VIZIO_PORT=7345 \
  -e VIZIO_AUTH_TOKEN=your_token \
  YOUR_DOCKERHUB_USERNAME/vizio-api:latest
```
```

### 5.2 Add Docker Hub Badge

Add this to your README.md:

```markdown
[![Docker Hub](https://img.shields.io/docker/pulls/YOUR_DOCKERHUB_USERNAME/vizio-api.svg)](https://hub.docker.com/r/YOUR_DOCKERHUB_USERNAME/vizio-api)
```

## Step 6: Test Your Published Image

### 6.1 Pull and Test

```bash
# Pull your published image
docker pull YOUR_DOCKERHUB_USERNAME/vizio-api:latest

# Test it
docker run --rm -p 8000:8000 \
  -e VIZIO_IP=192.168.1.100 \
  -e VIZIO_PORT=7345 \
  -e VIZIO_AUTH_TOKEN=your_token \
  YOUR_DOCKERHUB_USERNAME/vizio-api:latest
```

## Step 7: Maintenance

### 7.1 Update Docker Image

When you make changes:

1. Update version in your code
2. Create new git tag: `git tag v1.0.1`
3. Push tag: `git push origin v1.0.1`
4. GitHub Actions will automatically build and push

### 7.2 Docker Hub Repository Settings

In your Docker Hub repository:

1. **Description**: Keep it updated
2. **Full Description**: Add detailed usage instructions
3. **Tags**: Organize your versions
4. **Build Settings**: Configure automated builds if needed

## Example Docker Hub Repository

Your Docker Hub repository should look like:

```
Repository: YOUR_DOCKERHUB_USERNAME/vizio-api
Description: FastAPI-based REST API for controlling Vizio SmartCast TVs
Tags: latest, v1.0.0, v1.0.1
Stars: ⭐⭐⭐⭐⭐
Pulls: 1,000+
```

## Benefits of Docker Hub Publishing

- ✅ **Easy Distribution**: Users can pull with one command
- ✅ **Version Control**: Tagged releases for stability
- ✅ **Automated Builds**: GitHub Actions handles publishing
- ✅ **Community**: Others can discover and use your project
- ✅ **Documentation**: Docker Hub provides usage examples

Your Vizio TV API will now be easily accessible to anyone who wants to use it! 🐳 