# Nginx Proxy Manager Setup Guide

## Mixed Content Error Fix

The error "Blocked loading mixed active content" occurs when your nginx proxy manager is serving HTTPS but the backend API is trying to make HTTP requests.

### Solution 1: Force HTTPS in nginx proxy manager

1. **In nginx proxy manager:**
   - Go to your proxy host configuration
   - Enable "Force SSL" 
   - Enable "HTTP/2 Support"
   - Add custom location for health check:
     ```
     Location: /health
     Forward Hostname: localhost
     Forward Port: 30002
     ```

2. **Update your API calls to use HTTPS:**
   ```bash
   # Instead of:
   curl http://192.168.1.100:30002/health
   
   # Use:
   curl https://your-domain.com/health
   ```

### Solution 2: Configure API to use HTTPS internally

Update your `docker-compose.yml` to include HTTPS configuration:

```yaml
version: '3.8'

services:
  vizio-api:
    container_name: vizio-api
    image: passwordhelpme/vizio-api:latest
    environment:
      - TZ=America/New_York
      - VIZIO_IP=${VIZIO_IP:-192.168.1.100}
      - VIZIO_PORT=${VIZIO_PORT:-7345}
      - VIZIO_AUTH_TOKEN=${VIZIO_AUTH_TOKEN}
      - USE_HTTPS=true  # Add this line
    ports:
      - '30002:8000'
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "https://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    volumes:
      - ./logs:/app/logs
    networks:
      - vizio-network

networks:
  vizio-network:
    driver: bridge
```

### Solution 3: Use a reverse proxy with SSL termination

Create a separate nginx container for SSL termination:

```yaml
version: '3.8'

services:
  vizio-api:
    container_name: vizio-api
    image: passwordhelpme/vizio-api:latest
    environment:
      - TZ=America/New_York
      - VIZIO_IP=${VIZIO_IP:-192.168.1.100}
      - VIZIO_PORT=${VIZIO_PORT:-7345}
      - VIZIO_AUTH_TOKEN=${VIZIO_AUTH_TOKEN}
    expose:
      - '8000'
    restart: unless-stopped
    networks:
      - vizio-network

  nginx-proxy:
    image: nginx:alpine
    container_name: vizio-nginx
    ports:
      - '30002:80'
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - vizio-api
    networks:
      - vizio-network

networks:
  vizio-network:
    driver: bridge
```

Create `nginx.conf`:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream vizio_api {
        server vizio-api:8000;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://vizio_api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

### Recommended Approach

**Use Solution 1** - it's the simplest and most reliable:

1. In nginx proxy manager:
   - Domain: `your-domain.com`
   - Scheme: `https`
   - Forward Hostname: `localhost`
   - Forward Port: `30002`
   - Enable "Force SSL"
   - Enable "HTTP/2 Support"

2. Test your API:
   ```bash
   curl https://your-domain.com/health
   curl -X POST https://your-domain.com/tv/power \
     -H "Content-Type: application/json" \
     -d '{"power": "on"}'
   ```

### Troubleshooting

If you still get mixed content errors:

1. **Check browser console** for specific URLs causing issues
2. **Clear browser cache** and try again
3. **Use browser dev tools** to see if any HTTP requests are being made
4. **Check nginx proxy manager logs** for any errors

### Environment Variables for Docker Compose

Create `.env` file:
```bash
VIZIO_IP=192.168.1.100
VIZIO_PORT=7345
VIZIO_AUTH_TOKEN=your_auth_token_here
```

Then run:
```bash
docker-compose up -d
``` 