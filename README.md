# Vizio TV API

A FastAPI-based REST API for controlling Vizio SmartCast TVs using the pyvizio library.

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-green.svg)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This API provides endpoints to control power, volume, inputs, apps, and more.

## Features

- **Power Control**: Turn TV on/off
- **Volume Control**: Set and get volume levels
- **Input Management**: Switch between different inputs (HDMI, SmartCast, etc.)
- **App Control**: Launch apps on the TV
- **Mute Control**: Mute/unmute the TV
- **Health Monitoring**: Health check endpoints
- **Container Support**: Docker and Docker Compose ready
- **Environment Variables**: Configurable via environment variables

## Prerequisites

- Python 3.8+
- A Vizio smart TV on your network
- TV's IP address
- (Optional) TV's auth token for enhanced security

## Setup

### 1. Find Your TV's IP Address

First, you need to find your TV's IP address on your network. You can usually find this in your TV's network settings or router admin panel.

### 2. Get Auth Token (Optional but Recommended)

To get your TV's auth token, you can use the pyvizio CLI:

```bash
pip install pyvizio
pyvizio --ip YOUR_TV_IP discover
```

### 3. Environment Variables

Copy the example environment file and update it with your TV's configuration:

```bash
cp env.example .env
```

Then edit `.env` with your TV's details:

```env
# TV IP Address (required)
VIZIO_IP=192.168.1.100

# TV Port (optional, defaults to 7345)
VIZIO_PORT=7345

# TV Auth Token (optional, but recommended)
VIZIO_AUTH_TOKEN=your_auth_token_here
```

## Installation

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd vizio-api
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up environment variables (see above)

4. Run the API:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### Docker

1. Build and run with Docker Compose:
```bash
docker-compose up --build
```

2. Or build and run manually:
```bash
docker build -t vizio-api .
docker run -p 8000:8000 --env-file .env vizio-api
```

## API Endpoints

### Health & Info

- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /tv/info` - Get TV information (power, volume, input)

### Power Control

- `GET /tv/power` - Get current power state
- `POST /tv/power` - Set power state
  ```json
  {
    "power": "on"  // or "off"
  }
  ```

### Volume Control

- `GET /tv/volume` - Get current volume
- `POST /tv/volume` - Set volume
  ```json
  {
    "volume": 50  // 0-100
  }
  ```

### Input Control

- `GET /tv/input` - Get current input
- `GET /tv/inputs` - Get available inputs
- `POST /tv/input` - Set input
  ```json
  {
    "input_name": "HDMI-1"
  }
  ```

### App Control

- `GET /tv/apps` - Get available apps
- `POST /tv/app` - Launch app
  ```json
  {
    "app_name": "Netflix"
  }
  ```

### Mute Control

- `GET /tv/mute` - Get mute state
- `POST /tv/mute?muted=true` - Set mute state

## API Documentation

Once the server is running, you can access the interactive API documentation at:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Usage Examples

### Using curl

```bash
# Get TV info
curl http://localhost:8000/tv/info

# Turn TV on
curl -X POST http://localhost:8000/tv/power \
  -H "Content-Type: application/json" \
  -d '{"power": "on"}'

# Set volume to 50%
curl -X POST http://localhost:8000/tv/volume \
  -H "Content-Type: application/json" \
  -d '{"volume": 50}'

# Switch to HDMI-1
curl -X POST http://localhost:8000/tv/input \
  -H "Content-Type: application/json" \
  -d '{"input_name": "HDMI-1"}'

# Launch Netflix
curl -X POST http://localhost:8000/tv/app \
  -H "Content-Type: application/json" \
  -d '{"app_name": "Netflix"}'
```

### Using Python requests

```python
import requests

base_url = "http://localhost:8000"

# Turn TV on
response = requests.post(f"{base_url}/tv/power", json={"power": "on"})
print(response.json())

# Set volume
response = requests.post(f"{base_url}/tv/volume", json={"volume": 75})
print(response.json())

# Get TV info
response = requests.get(f"{base_url}/tv/info")
print(response.json())
```

## Common Input Names

- `HDMI-1`, `HDMI-2`, `HDMI-3`, etc.
- `SMARTCAST`
- `COMPONENT`
- `AV`
- `USB`

## Common App Names

- `Netflix`
- `YouTube`
- `Amazon Prime Video`
- `Hulu`
- `Disney+`
- `HBO Max`

## Troubleshooting

### TV Not Responding

1. Check that your TV's IP address is correct
2. Ensure your TV is on the same network as the API
3. Try getting the auth token using the pyvizio CLI
4. Check that your TV's network discovery is enabled

### Connection Issues

1. Verify the TV is powered on
2. Check firewall settings
3. Ensure the TV port (default 7345) is accessible
4. Try restarting the TV

### Auth Token Issues

If you're having trouble with authentication:
1. Try running without an auth token first
2. Use the pyvizio CLI to discover your TV and get the token
3. Some TVs may not require an auth token

## Development

### Running Tests

```bash
# Install test dependencies
pip install pytest httpx

# Run tests
pytest
```

### Logging

The API logs to stdout and stderr. In Docker, you can view logs with:
```bash
docker-compose logs -f
```

## License

This project is licensed under the MIT License.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request 