# GraphSmile Mobile Backend API Documentation

## Base URL
```
http://localhost:8002
```

## Authentication
No authentication required for this demo version.

## Endpoints

### 1. Health Check
Check if the backend server is running and healthy.

**Endpoint:** `GET /health`

**Response:**
```json
{
  "status": "healthy",
  "version": "3.0.0",
  "server": "GraphSmile Mobile Backend",
  "timestamp": "2025-07-04T12:00:00.000Z",
  "uptime": "Running"
}
```

### 2. Video Analysis
Analyze emotions in a video from URL and get a summary snapshot.

**Endpoint:** `POST /analyze-video`

**Request Body:**
```json
{
  "video_url": "https://youtube.com/watch?v=example",
  "frame_interval": 30,
  "max_frames": 5
}
```

**Parameters:**
- `video_url` (required): URL of the video to analyze
- `frame_interval` (optional): Interval between frames to analyze (default: 30)
- `max_frames` (optional): Maximum number of frames to analyze (default: 5)

**Response:**
```json
{
  "frames_analyzed": 5,
  "dominant_emotion": "happy",
  "average_confidence": 0.89,
  "summary_snapshot": {
    "emotion": "happy",
    "sentiment": "positive",
    "confidence": 0.89,
    "subtitle": "Video analysis of 5 frames shows predominantly happy emotion with positive sentiment. Analysis confidence: 89%. This indicates a favorable emotional tone throughout the content.",
    "frame_image_base64": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
    "total_frames_analyzed": 5,
    "emotion_distribution": {
      "happy": 3,
      "excited": 1,
      "confident": 1
    }
  },
  "processing_time_ms": 2500,
  "timestamp": "2025-07-04T12:00:00.000Z"
}
```

### 3. Error Responses
All endpoints return appropriate HTTP status codes and error messages.

**Error Response Format:**
```json
{
  "error": "Description of the error"
}
```

**Common Status Codes:**
- `200`: Success
- `400`: Bad Request (missing required parameters)
- `500`: Internal Server Error

## Flutter Integration

### Using the Video Analysis Cubit

#### 1. Setup in your widget:
```dart
BlocProvider<VideoAnalysisCubit>(
  create: (_) => sl<VideoAnalysisCubit>(),
  child: YourWidget(),
)
```

#### 2. Trigger analysis:
```dart
context.read<VideoAnalysisCubit>().analyzeVideo(
  videoUrl: 'https://youtube.com/watch?v=example',
  frameInterval: 30,
  maxFrames: 5,
);
```

#### 3. Listen to state changes:
```dart
BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
  builder: (context, state) {
    if (state is VideoAnalysisLoading) {
      return CircularProgressIndicator();
    } else if (state is VideoAnalysisSuccess) {
      return DisplayResults(result: state.result);
    } else if (state is VideoAnalysisError) {
      return ErrorMessage(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

## State Management Architecture

### States:
- `VideoAnalysisInitial`: Initial state
- `VideoAnalysisLoading`: Analysis in progress
- `VideoAnalysisSuccess`: Analysis completed successfully
- `VideoAnalysisError`: Analysis failed
- `VideoAnalysisDemo`: Showing demo data (fallback)

### Benefits:
- Clean separation of concerns
- Reactive UI updates
- Easy error handling
- Predictable state flow
- Testable architecture

## Backend Setup

### Dependencies:
```bash
pip install flask flask-cors
```

### Running the server:
```bash
python backend_server.py
```

### Server will start on:
```
http://localhost:8002
```

## Development Notes

1. **Mock Data**: The backend provides realistic mock data for testing
2. **Error Handling**: Graceful fallback to demo data if backend is unavailable
3. **Responsive UI**: The Flutter app adapts to different screen sizes
4. **Real-time Updates**: State management ensures UI updates immediately when data changes
5. **Extensible**: Easy to add new features and endpoints

## Example Usage

### Complete analysis flow:
1. User enters video URL
2. App sends POST request to `/analyze-video`
3. Backend processes video and returns summary snapshot
4. Cubit emits new state with results
5. UI automatically updates to show results

### Error handling:
1. If backend is unavailable, app shows demo data
2. If invalid URL, app shows error message
3. If network fails, app gracefully handles the error
