# Backend API Setup Guide

This guide will help you easily connect your GraphSmile Mobile app to a backend server for emotion analysis.

## Quick Setup (5 Minutes)

### 1. Configure Your Backend URL

Update the API base URL in `lib/core/config/app_config.dart`:

```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:8002';
```

**Examples:**
- Local development: `'http://localhost:8002'`
- Same network: `'http://192.168.1.100:8002'`
- Cloud server: `'https://your-api.herokuapp.com'`

### 2. Disable Mock Mode

In `lib/data/services/emotion_api_service.dart`, change:

```dart
static const bool _useMockData = false; // Set to false for production
```

### 3. Test Connection

Run the app and check the Dashboard → Connection Status to verify connectivity.

## Backend Server Options

### Option 1: Use Included Python Server (Recommended)

The project includes `backend_server.py` which provides a complete API:

#### Start the Server:

```bash
# Install dependencies
pip install flask flask-cors pillow

# Run the server
python backend_server.py
```

The server will start on `http://localhost:8002` with these endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/predict` | POST | Analyze single text |
| `/batch-predict` | POST | Analyze multiple texts |
| `/analyze-video` | POST | Video emotion analysis |
| `/metrics` | GET | System performance |
| `/analytics` | GET | Usage analytics |
| `/model-info` | GET | AI model information |
| `/demo` | GET | Demo data |
| `/cache-stats` | GET | Cache statistics |

#### Deploy to Cloud:

**Heroku Deployment:**
```bash
# Create Procfile
echo "web: python backend_server.py" > Procfile

# Deploy
git add .
git commit -m "Deploy backend"
heroku create your-app-name
git push heroku main
```

**Update app config:**
```dart
static const String baseUrl = 'https://your-app-name.herokuapp.com';
```

### Option 2: Custom Backend

If you have your own backend, ensure it implements these endpoints:

#### Required Endpoints:

**Health Check:**
```http
GET /health
Response: {"status": "ok", "version": "1.0"}
```

**Text Analysis:**
```http
POST /predict
Content-Type: application/json

Request:
{
  "text": "I am feeling great today!"
}

Response:
{
  "emotion": "joy",
  "sentiment": "positive", 
  "confidence": 0.92,
  "all_emotions": {
    "joy": 0.92,
    "sadness": 0.02,
    "anger": 0.01,
    "fear": 0.01,
    "surprise": 0.02,
    "disgust": 0.01,
    "neutral": 0.01
  },
  "processing_time_ms": 150
}
```

**Batch Analysis:**
```http
POST /batch-predict
Content-Type: application/json

Request:
{
  "texts": ["Happy text", "Sad text"]
}

Response:
{
  "results": [
    {
      "emotion": "joy",
      "sentiment": "positive",
      "confidence": 0.90,
      "all_emotions": {...},
      "processing_time_ms": 120
    },
    {
      "emotion": "sadness", 
      "sentiment": "negative",
      "confidence": 0.85,
      "all_emotions": {...},
      "processing_time_ms": 130
    }
  ]
}
```

## Network Configuration

### Local Network Setup

To connect devices on the same network:

1. Find your computer's IP address:
   - Windows: `ipconfig`
   - Mac/Linux: `ifconfig` or `ip addr`

2. Update the app config:
```dart
static const String baseUrl = 'http://192.168.1.100:8002'; // Your IP
```

3. Allow firewall access (if needed):
   - Windows: Add Python to Windows Firewall exceptions
   - Mac: System Preferences → Security → Firewall → Options
   - Linux: `sudo ufw allow 8002`

### CORS Configuration

For web deployment, ensure CORS is enabled in your backend:

```python
from flask_cors import CORS
app = Flask(__name__)
CORS(app)  # Enable CORS for all domains
```

## Authentication (Optional)

If your backend requires authentication:

### 1. API Key Authentication

Update `app_config.dart`:
```dart
static const String apiKey = 'your-api-key-here';
```

### 2. Bearer Token Authentication

The app automatically adds Bearer token headers if `apiKey` is set:
```http
Authorization: Bearer your-api-key-here
```

### 3. Custom Headers

Add custom headers in `app_config.dart`:
```dart
static const Map<String, String> defaultHeaders = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-API-Key': 'your-custom-key',
  'X-Client-Version': '1.0.0',
};
```

## Advanced Configuration

### Timeout Settings

Adjust timeouts in `app_config.dart`:
```dart
static const int connectTimeout = 30000; // 30 seconds
static const int receiveTimeout = 30000; // 30 seconds
static const int healthCheckTimeout = 5000; // 5 seconds
static const int videoAnalysisTimeout = 120000; // 2 minutes
```

### Retry Configuration

Configure automatic retry behavior:
```dart
static const int maxRetryAttempts = 3;
static const int retryDelay = 1000; // 1 second
static const bool useExponentialBackoff = true;
```

### Feature Flags

Enable/disable features based on your backend capabilities:
```dart
static const bool enableVoiceAnalysis = true;
static const bool enableVideoAnalysis = true;
static const bool enableBatchProcessing = true;
static const bool enableRealtimeAnalysis = false;
```

## Testing Your Setup

### 1. Connection Test

Use the built-in connection tester in the app's Dashboard screen.

### 2. Debug Mode

Enable debug logging to see detailed API communication in the console.

## Troubleshooting

### Common Issues

**Connection Refused:**
- Check if backend server is running
- Verify IP address and port
- Check firewall settings

**Timeout Errors:**
- Increase timeout values in config
- Check network stability
- Verify server performance

**CORS Errors (Web):**
- Enable CORS in backend
- Add proper headers
- Check browser console for details

**Authentication Errors:**
- Verify API key is correct
- Check authorization headers
- Confirm backend auth requirements

### Mock Mode for Development

During development, you can use mock data by keeping:

```dart
static const bool _useMockData = true; // Enable mock mode
```

This provides realistic responses without requiring a backend server.

## Production Deployment

### Security Checklist

- [ ] Use HTTPS for production
- [ ] Implement proper authentication
- [ ] Set up rate limiting
- [ ] Configure proper CORS
- [ ] Monitor API usage
- [ ] Set up error logging
- [ ] Use environment variables for sensitive data

### Performance Optimization

- [ ] Enable response caching
- [ ] Use connection pooling
- [ ] Implement request batching
- [ ] Monitor response times
- [ ] Set up load balancing (if needed)

### Monitoring

Set up monitoring for:
- API response times
- Error rates
- Usage patterns
- Server health metrics

## Support

If you encounter issues:

1. Check the console logs for detailed error messages
2. Verify your backend server is responding to health checks
3. Test with the included Python backend first
4. Review the network configuration
5. Check the troubleshooting section above

For more help, check the project documentation or create an issue on the repository. 