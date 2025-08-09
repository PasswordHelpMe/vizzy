# Vizio API Documentation

## Enhanced `/tv/info` Endpoint

The `/tv/info` endpoint now provides comprehensive real-time information about your Vizio TV by making actual calls to the TV's API and interpreting the responses.

### Endpoint
```
GET /tv/info
```

### Response Format

```json
{
  "power": "On",              // Interpreted power state: "On", "Off", "Standby", "Unknown"
  "power_mode": 1,            // Raw power mode value from TV (0=Off, 1=On, 2=Standby)
  "volume": 25,               // Current volume level (0-100)
  "input": "HDMI-1",          // Current input source
  "muted": false,             // Mute status (true/false)
  "ip": "192.168.1.110",      // TV IP address
  "port": "7345",             // TV port
  "auth_token_set": true      // Whether auth token is configured
}
```

### Power State Interpretation

The backend now calls the actual Vizio TV power mode endpoint (`/state/device/power_mode`) and interprets the raw values:

| Raw Value | Interpreted Status | Description |
|-----------|-------------------|-------------|
| `0`       | `"Off"`           | TV is completely off |
| `1`       | `"On"`            | TV is on and active |
| `2`       | `"Standby"`       | TV is in standby mode |
| Other     | `"Unknown"`       | Unrecognized power state |

### Real-Time Data

The endpoint makes the following real-time calls to your TV:

1. **Power State**: `tv.get_power_state()` - Gets current power mode
2. **Volume**: `tv.get_current_volume()` - Gets current volume level
3. **Input**: `tv.get_current_input()` - Gets current input source
4. **Mute Status**: `tv.is_muted()` - Gets current mute state

### Error Handling

If any individual TV call fails, the endpoint will:
- Set that field to a safe default value
- Add an `*_error` field with the error message
- Continue processing other fields

Example with errors:
```json
{
  "power": "Unknown",
  "power_mode": null,
  "power_error": "Connection timeout",
  "volume": 0,
  "volume_error": "Failed to get volume",
  "input": "Unknown",
  "muted": false,
  "ip": "192.168.1.110",
  "port": "7345",
  "auth_token_set": true
}
```

### Usage Examples

#### cURL
```bash
curl https://your-domain.com/tv/info
```

#### JavaScript (Fetch)
```javascript
fetch('https://your-domain.com/tv/info')
  .then(response => response.json())
  .then(data => {
    console.log('TV Power:', data.power);
    console.log('Volume:', data.volume);
    console.log('Input:', data.input);
    console.log('Muted:', data.muted);
  });
```

#### Python (Requests)
```python
import requests

response = requests.get('https://your-domain.com/tv/info')
tv_info = response.json()

print(f"TV is {tv_info['power']}")
print(f"Volume: {tv_info['volume']}")
print(f"Input: {tv_info['input']}")
print(f"Muted: {tv_info['muted']}")
```

### Benefits

1. **Real-Time Data**: Returns actual current state from the TV
2. **Interpreted Values**: Converts raw API responses to human-readable format
3. **Comprehensive Info**: Single endpoint provides all key TV status information
4. **Error Resilient**: Individual failures don't break the entire response
5. **CORS Compatible**: Works with web applications and cross-origin requests

### Migration from Old Format

If you were using the old `/tv/info` format, update your code:

| Old Field | New Field | Notes |
|-----------|-----------|-------|
| `power_state` | `power` | Now interpreted as "On"/"Off"/"Standby" |
| `volume` | `volume` | Same, but now guaranteed to be a number |
| `current_input` | `input` | Renamed for consistency |
| N/A | `muted` | New field for mute status |
| N/A | `power_mode` | New field with raw power mode value |

## Other Endpoints

### Health Check
```
GET /health
```
Returns server and TV connection status.

### Power Control
```
POST /tv/power
Content-Type: application/json

{
  "power": "on"  // or "off"
}
```

### Volume Control
```
GET /tv/volume    // Get current volume
POST /tv/volume   // Set volume (implementation varies)
```

### Input Control
```
GET /tv/input     // Get current input
POST /tv/input    // Set input
```

For complete API documentation, see the FastAPI docs at `/docs` when running the server.