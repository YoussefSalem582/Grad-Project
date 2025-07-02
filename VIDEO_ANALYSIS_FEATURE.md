# Video Analysis: Customer Review Snapshot

## Overview
Get a single, comprehensive visual summary of customer sentiment from video content. Our system analyzes the entire video and produces one high-quality snapshot with clear emotional analysis.

## Key Features
- **Video URL Support**: YouTube, Vimeo, and other platforms
- **Single Summary Image**: High-resolution 320×240px snapshot
- **Emotion Analysis**: Overall sentiment with confidence scoring
- **Customer Review Context**: Summarized text of key points

## How It Works
1. Enter video URL in the Video Analysis tab
2. System processes the entire video content
3. AI analyzes dominant emotions across all frames
4. Results displayed as a single comprehensive snapshot:
   - Clear 320×240px summary image
   - Dominant emotion label (Happy, Confident, etc.)
   - Overall confidence percentage
   - Customer review summary text
   - Emotion distribution metrics

## Technical Details
- **Backend**: Full video analysis with emotion aggregation
- **Frontend**: Professional summary display with high-res image
- **Image Specs**: 320×240px, emotion-coded colors, clear facial indicators
- **Performance**: Optimized processing, single image generation

## API Response
```json
{
  "frames_analyzed": 82,
  "dominant_emotion": "Confident",
  "average_confidence": 0.87,
  "summary_snapshot": {
    "emotion": "Confident",
    "sentiment": "positive",
    "confidence": 0.87,
    "subtitle": "Customer review analysis: Confident sentiment detected with 87% confidence",
    "frame_image_base64": "...",
    "emotion_distribution": {
      "confident": 42,
      "happy": 28,
      "neutral": 12
    }
  }
}
```

## Benefits
- **Clear Visual Summary**: One comprehensive image instead of multiple frames
- **Professional Presentation**: Properly sized, high-quality snapshot
- **Quick Analysis**: Immediate understanding of overall customer sentiment
- **Standardized Format**: Consistent 320×240px image dimensions for all analyses
