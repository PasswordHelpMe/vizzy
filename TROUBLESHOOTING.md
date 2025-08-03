# Troubleshooting Guide

## Docker Networking Issues

### Problem: "failed to resolve source metadata for docker.io/library/python"

This error occurs when Docker can't reach the Docker Hub registry due to networking issues.

#### Solutions:

1. **Use Local Python (Recommended for quick start):**
   ```bash
   ./start_local.sh
   ```

2. **Fix Docker Networking:**
   - Restart Docker Desktop
   - Go to Docker Desktop → Settings → Resources → Advanced
   - Increase memory allocation to at least 4GB
   - Restart Docker Desktop

3. **Use Alternative Base Image:**
   The Dockerfile now uses `python:3.11-alpine` which is smaller and more reliable.

4. **Check DNS Settings:**
   ```bash
   # Test DNS resolution
   nslookup registry-1.docker.io
   
   # If DNS fails, try using Google DNS
   # Add to Docker Desktop settings: 8.8.8.8, 8.8.4.4
   ```

5. **Build Without Network:**
   ```bash
   docker-compose build --no-cache
   docker-compose up
   ```

## Common Issues

### TV Not Responding

1. **Check TV IP Address:**
   - Ensure the IP address in `.env` is correct
   - Find your TV's IP in TV settings → Network → Network Status

2. **Check Network Connectivity:**
   ```bash
   # Test if TV is reachable
   ping YOUR_TV_IP
   
   # Test port connectivity
   telnet YOUR_TV_IP 7345
   ```

3. **Get Auth Token:**
   ```bash
   pip install pyvizio
   pyvizio --ip YOUR_TV_IP discover
   ```

### API Not Starting

1. **Check Environment Variables:**
   ```bash
   # Verify .env file exists and has correct values
   cat .env
   ```

2. **Check Port Availability:**
   ```bash
   # Check if port 8000 is in use
   lsof -i :8000
   ```

3. **Check Python Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

### Permission Issues

1. **Make scripts executable:**
   ```bash
   chmod +x start.sh start_local.sh
   ```

2. **Check file permissions:**
   ```bash
   ls -la *.sh
   ```

## Alternative Startup Methods

### Method 1: Local Python (Recommended)
```bash
./start_local.sh
```

### Method 2: Manual Python Setup
```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start API
python main.py
```

### Method 3: Docker with Network Fix
```bash
# Restart Docker Desktop first, then:
docker-compose up --build
```

### Method 4: Direct Docker Run
```bash
docker build -t vizio-api .
docker run -p 8000:8000 --env-file .env vizio-api
```

## Testing the API

Once the API is running, test it with:

```bash
# Test health endpoint
curl http://localhost:8000/health

# Test TV info
curl http://localhost:8000/tv/info

# Run full test suite
python test_api.py
```

## Getting Help

If you're still having issues:

1. Check the logs:
   ```bash
   # For local Python
   tail -f logs/app.log
   
   # For Docker
   docker-compose logs -f
   ```

2. Verify your TV settings:
   - TV is powered on
   - TV is connected to the same network
   - TV's network discovery is enabled
   - Firewall allows connections to port 7345

3. Test with pyvizio CLI first:
   ```bash
   pip install pyvizio
   pyvizio --ip YOUR_TV_IP discover
   ``` 