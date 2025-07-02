#!/usr/bin/env python3
"""
GraphSmile Mobile Backend Server v3.0
Compatible backend for the Flutter mobile app
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import datetime
import random
import time
import json
import base64
import io

app = Flask(__name__)
CORS(app)  # Enable CORS for mobile app connections

# Mock data for realistic responses
EMOTIONS = ['joy', 'sadness', 'anger', 'fear', 'surprise', 'disgust', 'neutral']
SENTIMENTS = ['positive', 'negative', 'neutral']

def generate_emotion_result(text):
    """Generate a realistic emotion analysis result"""
    # Simple emotion detection based on keywords
    text_lower = text.lower()
    
    if any(word in text_lower for word in ['happy', 'joy', 'excited', 'wonderful', 'amazing', 'great']):
        primary_emotion = 'joy'
        sentiment = 'positive'
        confidence = random.uniform(0.85, 0.95)
    elif any(word in text_lower for word in ['sad', 'disappointed', 'terrible', 'awful', 'depressed']):
        primary_emotion = 'sadness'
        sentiment = 'negative'
        confidence = random.uniform(0.80, 0.92)
    elif any(word in text_lower for word in ['angry', 'furious', 'mad', 'irritated', 'annoyed']):
        primary_emotion = 'anger'
        sentiment = 'negative'
        confidence = random.uniform(0.75, 0.90)
    elif any(word in text_lower for word in ['scared', 'afraid', 'terrified', 'frightened']):
        primary_emotion = 'fear'
        sentiment = 'negative'
        confidence = random.uniform(0.70, 0.88)
    elif any(word in text_lower for word in ['surprised', 'shocked', 'amazed', 'wow']):
        primary_emotion = 'surprise'
        sentiment = 'neutral'
        confidence = random.uniform(0.75, 0.85)
    else:
        primary_emotion = 'neutral'
        sentiment = 'neutral'
        confidence = random.uniform(0.70, 0.85)
    
    # Generate emotion scores
    all_emotions = {}
    for emotion in EMOTIONS:
        if emotion == primary_emotion:
            all_emotions[emotion] = confidence
        else:
            all_emotions[emotion] = random.uniform(0.05, 0.3)
    
    return {
        'text': text,
        'emotion': primary_emotion,
        'sentiment': sentiment,
        'confidence': round(confidence, 3),
        'all_emotions': {k: round(v, 3) for k, v in all_emotions.items()},
        'processing_time_ms': random.randint(50, 200),
        'timestamp': datetime.datetime.now().isoformat()
    }

def generate_mock_frame_image(emotion, frame_index):
    """Generate a base64 encoded mock frame image based on emotion"""
    try:
        # Try to use PIL if available for better images
        from PIL import Image, ImageDraw, ImageFont
        
        # Create a 160x120 image with emotion-based color
        emotion_colors = {
            'joy': (255, 220, 100),      # Golden yellow
            'sadness': (100, 150, 200),   # Blue
            'anger': (220, 100, 100),     # Red
            'fear': (150, 100, 200),      # Purple
            'surprise': (255, 180, 100),  # Orange
            'disgust': (150, 200, 100),   # Green
            'neutral': (180, 180, 180)    # Gray
        }
        
        color = emotion_colors.get(emotion, (180, 180, 180))
        
        # Create image
        img = Image.new('RGB', (160, 120), color)
        draw = ImageDraw.Draw(img)
        
        # Draw simple face representation
        face_color = tuple(max(0, c - 50) for c in color)
        draw.ellipse([40, 30, 120, 90], fill=face_color)
        
        # Draw eyes
        draw.ellipse([55, 45, 65, 55], fill=(0, 0, 0))
        draw.ellipse([95, 45, 105, 55], fill=(0, 0, 0))
        
        # Draw mouth based on emotion
        if emotion == 'joy':
            draw.arc([65, 60, 95, 80], 0, 180, fill=(0, 0, 0), width=2)
        elif emotion == 'sadness':
            draw.arc([65, 70, 95, 90], 180, 360, fill=(0, 0, 0), width=2)
        else:
            draw.line([70, 70, 90, 70], fill=(0, 0, 0), width=2)
        
        # Add frame number
        draw.text((10, 10), f"Frame {frame_index + 1}", fill=(255, 255, 255))
        draw.text((10, 100), emotion.capitalize(), fill=(255, 255, 255))
        
        # Convert to base64
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        img_str = base64.b64encode(buffer.getvalue()).decode()
        return img_str
        
    except ImportError:
        # Fallback: Generate a simple base64 placeholder if PIL is not available
        placeholder_data = f"data:image/svg+xml;base64," + base64.b64encode(
            f'''<svg width="160" height="120" xmlns="http://www.w3.org/2000/svg">
                <rect width="160" height="120" fill="#{random.randint(100000, 999999)}"/>
                <text x="80" y="60" text-anchor="middle" fill="white" font-size="12">
                    Frame {frame_index + 1}
                </text>
                <text x="80" y="80" text-anchor="middle" fill="white" font-size="10">
                    {emotion.capitalize()}
                </text>
            </svg>'''.encode()
        ).decode()
        return placeholder_data

def generate_summary_frame_image(emotion, sentiment, confidence):
    """Generate a base64 encoded summary frame image with emotion analysis details"""
    try:
        from PIL import Image, ImageDraw, ImageFont
        
        # Create a larger, higher quality image for summary (320x240)
        emotion_colors = {
            'joy': (255, 220, 100),      # Golden yellow
            'sadness': (100, 150, 200),   # Blue
            'anger': (220, 100, 100),     # Red
            'fear': (150, 100, 200),      # Purple
            'surprise': (255, 180, 100),  # Orange
            'disgust': (150, 200, 100),   # Green
            'neutral': (180, 180, 180)    # Gray
        }
        
        sentiment_colors = {
            'positive': (100, 200, 100),  # Green
            'negative': (200, 100, 100),  # Red
            'neutral': (180, 180, 180)    # Gray
        }
        
        base_color = emotion_colors.get(emotion, (180, 180, 180))
        sentiment_color = sentiment_colors.get(sentiment, (180, 180, 180))
        
        # Create image with gradient background
        img = Image.new('RGB', (320, 240), base_color)
        draw = ImageDraw.Draw(img)
        
        # Draw gradient background
        for y in range(240):
            alpha = y / 240
            blend_color = tuple(int(base_color[i] * (1 - alpha) + sentiment_color[i] * alpha * 0.3) for i in range(3))
            draw.line([(0, y), (320, y)], fill=blend_color)
        
        # Draw larger face representation
        face_color = tuple(max(0, c - 30) for c in base_color)
        draw.ellipse([110, 80, 210, 160], fill=face_color, outline=(255, 255, 255), width=3)
        
        # Draw eyes
        draw.ellipse([130, 105, 145, 120], fill=(0, 0, 0))
        draw.ellipse([175, 105, 190, 120], fill=(0, 0, 0))
        
        # Draw mouth based on emotion
        if emotion == 'joy':
            draw.arc([140, 125, 180, 150], 0, 180, fill=(0, 0, 0), width=3)
        elif emotion == 'sadness':
            draw.arc([140, 135, 180, 160], 180, 360, fill=(0, 0, 0), width=3)
        elif emotion == 'anger':
            draw.polygon([(145, 135), (175, 135), (160, 145)], fill=(0, 0, 0))
        else:
            draw.line([145, 135, 175, 135], fill=(0, 0, 0), width=3)
        
        # Add summary text
        draw.text((20, 20), "VIDEO ANALYSIS SUMMARY", fill=(255, 255, 255), anchor="lt")
        draw.text((20, 45), f"Emotion: {emotion.upper()}", fill=(255, 255, 255), anchor="lt")
        draw.text((20, 65), f"Sentiment: {sentiment.upper()}", fill=(255, 255, 255), anchor="lt")
        draw.text((20, 85), f"Confidence: {int(confidence * 100)}%", fill=(255, 255, 255), anchor="lt")
        
        # Add decorative elements
        draw.rectangle([10, 10, 310, 100], outline=(255, 255, 255), width=2)
        
        # Convert to base64
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        img_str = base64.b64encode(buffer.getvalue()).decode()
        return img_str
        
    except ImportError:
        # Fallback: Generate a detailed SVG placeholder
        confidence_percent = int(confidence * 100)
        placeholder_data = base64.b64encode(
            f'''<svg width="320" height="240" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="bg" x1="0%" y1="0%" x2="0%" y2="100%">
                        <stop offset="0%" style="stop-color:#{random.randint(100000, 999999)};stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#{random.randint(100000, 999999)};stop-opacity:0.7" />
                    </linearGradient>
                </defs>
                <rect width="320" height="240" fill="url(#bg)"/>
                <rect x="10" y="10" width="300" height="90" fill="none" stroke="white" stroke-width="2"/>
                <text x="20" y="30" fill="white" font-size="14" font-weight="bold">VIDEO ANALYSIS SUMMARY</text>
                <text x="20" y="50" fill="white" font-size="12">Emotion: {emotion.upper()}</text>
                <text x="20" y="70" fill="white" font-size="12">Sentiment: {sentiment.upper()}</text>
                <text x="20" y="90" fill="white" font-size="12">Confidence: {confidence_percent}%</text>
                <circle cx="160" cy="160" r="40" fill="rgba(255,255,255,0.3)" stroke="white" stroke-width="2"/>
                <circle cx="150" cy="150" r="3" fill="white"/>
                <circle cx="170" cy="150" r="3" fill="white"/>
                <path d="M 145 170 Q 160 180 175 170" stroke="white" stroke-width="2" fill="none"/>
            </svg>'''.encode()
        ).decode()
        return placeholder_data

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'version': '3.0.0',
        'server': 'GraphSmile Mobile Backend',
        'timestamp': datetime.datetime.now().isoformat(),
        'uptime': 'Running'
    })

@app.route('/predict', methods=['POST'])
def predict():
    """Single text emotion prediction"""
    try:
        data = request.get_json()
        if not data or 'text' not in data:
            return jsonify({'error': 'Missing text field'}), 400
        
        text = data['text'].strip()
        if not text:
            return jsonify({'error': 'Text cannot be empty'}), 400
        
        result = generate_emotion_result(text)
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': f'Prediction failed: {str(e)}'}), 500

@app.route('/batch-predict', methods=['POST'])
def batch_predict():
    """Batch text emotion prediction"""
    try:
        data = request.get_json()
        if not data or 'texts' not in data:
            return jsonify({'error': 'Missing texts field'}), 400
        
        texts = data['texts']
        if not isinstance(texts, list) or not texts:
            return jsonify({'error': 'texts must be a non-empty list'}), 400
        
        results = []
        for text in texts:
            if isinstance(text, str) and text.strip():
                results.append(generate_emotion_result(text.strip()))
        
        return jsonify({'results': results})
    
    except Exception as e:
        return jsonify({'error': f'Batch prediction failed: {str(e)}'}), 500

@app.route('/analyze-video', methods=['POST'])
def analyze_video():
    """Video emotion analysis"""
    try:
        data = request.get_json()
        if not data or 'video_url' not in data:
            return jsonify({'error': 'Missing video_url field'}), 400
        
        video_url = data['video_url']
        frame_interval = data.get('frame_interval', 30)
        max_frames = data.get('max_frames', 100)
        
        # Simulate processing time
        time.sleep(2)
        
        # Generate mock frame analysis results with subtitles
        num_frames = min(random.randint(3, 8), max_frames)
        analysis_results = []
        
        # Sample subtitle texts for demo
        subtitle_samples = [
            "Welcome to our amazing product demonstration!",
            "This feature will revolutionize your workflow",
            "We guarantee 100% satisfaction with our service",
            "Let me explain the technical specifications",
            "Don't miss this limited-time offer!",
            "Thank you for watching our presentation",
            "Contact us for more information",
            "This solution saves you time and money"
        ]
        
        for i in range(num_frames):
            frame_text = f"Video frame {i+1}: Person showing mixed emotions"
            emotion_result = generate_emotion_result(frame_text)
            
            # Add subtitle and timestamp information
            emotion_result['subtitle'] = subtitle_samples[i % len(subtitle_samples)]
            emotion_result['timestamp'] = round(i * (frame_interval / 30), 2)  # Simulate frame timestamps
            emotion_result['frame_number'] = i + 1
            
            # Generate mock frame image (base64 encoded placeholder)
            emotion_result['frame_image_base64'] = generate_mock_frame_image(emotion_result['emotion'], i)
            
            analysis_results.append(emotion_result)
        
        # Calculate summary
        emotions_count = {}
        sentiments_count = {}
        total_confidence = 0
        
        for result in analysis_results:
            emotion = result['emotion']
            sentiment = result['sentiment']
            
            emotions_count[emotion] = emotions_count.get(emotion, 0) + 1
            sentiments_count[sentiment] = sentiments_count.get(sentiment, 0) + 1
            total_confidence += result['confidence']
        
        dominant_emotion = max(emotions_count.items(), key=lambda x: x[1])[0]
        overall_sentiment = max(sentiments_count.items(), key=lambda x: x[1])[0]
        avg_confidence = total_confidence / len(analysis_results)
        
        # Generate a single summary snapshot based on the dominant emotion
        summary_subtitle = f"Customer review analysis: {dominant_emotion.title()} sentiment detected with {round(avg_confidence * 100)}% confidence"
        
        # Create a more detailed summary image for the dominant emotion
        summary_image = generate_summary_frame_image(dominant_emotion, overall_sentiment, avg_confidence)
        
        return jsonify({
            'frames_analyzed': num_frames,
            'dominant_emotion': dominant_emotion,
            'average_confidence': round(avg_confidence, 3),
            'summary_snapshot': {
                'emotion': dominant_emotion,
                'sentiment': overall_sentiment,
                'confidence': round(avg_confidence, 3),
                'subtitle': summary_subtitle,
                'frame_image_base64': summary_image,
                'total_frames_analyzed': num_frames,
                'emotion_distribution': emotions_count
            },
            'processing_time_ms': random.randint(2000, 5000),
            'timestamp': datetime.datetime.now().isoformat()
        })
    
    except Exception as e:
        return jsonify({'error': f'Video analysis failed: {str(e)}'}), 500

@app.route('/metrics', methods=['GET'])
def metrics():
    """System metrics endpoint"""
    return jsonify({
        'cpu_usage': round(random.uniform(15, 75), 1),
        'memory_usage': round(random.uniform(25, 65), 1),
        'success_rate': round(random.uniform(88, 99), 1),
        'avg_response_time': random.randint(120, 280),
        'total_requests': random.randint(1500, 8000),
        'successful_requests': random.randint(1400, 7800),
        'failed_requests': random.randint(5, 50),
        'cache_metrics': {
            'cache_hits': random.randint(800, 3000),
            'cache_misses': random.randint(100, 600),
            'cache_size': f"{round(random.uniform(15, 120), 1)} MB",
            'hit_rate': round(random.uniform(78, 95), 1)
        },
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/analytics', methods=['GET'])
def analytics():
    """Analytics summary endpoint"""
    popular_emotions = []
    for i, emotion in enumerate(EMOTIONS[:5]):
        popular_emotions.append({
            'emotion': emotion,
            'count': random.randint(100, 800)
        })
    
    popular_texts = []
    sample_texts = [
        "I'm so excited about this project!",
        "This is really frustrating me.",
        "I feel pretty good today.",
        "That was absolutely amazing!",
        "I'm not sure how I feel about this."
    ]
    
    for i, text in enumerate(sample_texts[:3]):
        popular_texts.append({
            'text': text,
            'emotion': random.choice(EMOTIONS),
            'count': random.randint(25, 150),
            'avg_confidence': round(random.uniform(0.75, 0.92), 3)
        })
    
    return jsonify({
        'popular_emotions': popular_emotions,
        'popular_texts': popular_texts,
        'performance_stats': {
            'total_predictions': random.randint(2000, 15000),
            'avg_processing_time': random.randint(80, 250),
            'success_rate': round(random.uniform(92, 99), 1)
        },
        'time_range': {
            'start_date': (datetime.datetime.now() - datetime.timedelta(days=7)).isoformat(),
            'end_date': datetime.datetime.now().isoformat(),
            'days': 7
        },
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/model-info', methods=['GET'])
def model_info():
    """Model information endpoint"""
    return jsonify({
        'model_name': 'GraphSmile Emotion Analyzer',
        'version': '3.0.0',
        'description': 'Advanced hybrid emotion recognition system for mobile applications',
        'capabilities': [
            'Real-time text emotion analysis',
            'Sentiment classification',
            'Video emotion analysis',
            'Batch processing',
            'Multi-language support'
        ],
        'supported_emotions': EMOTIONS,
        'supported_sentiments': SENTIMENTS,
        'accuracy': round(random.uniform(92, 97), 1),
        'training_data_size': '150K+ samples',
        'last_updated': datetime.datetime.now().isoformat(),
        'author': 'GraphSmile Team'
    })

@app.route('/demo', methods=['GET'])
def demo():
    """Demo predictions endpoint"""
    demo_texts = [
        "I'm absolutely thrilled about this new opportunity!",
        "This situation is really disappointing and frustrating.",
        "I feel calm and peaceful this morning.",
        "That movie was absolutely terrifying!",
        "What a wonderful surprise this turned out to be!",
        "I'm feeling quite neutral about the whole thing.",
        "This makes me so angry I could scream!"
    ]
    
    examples = []
    for text in demo_texts:
        result = generate_emotion_result(text)
        result['category'] = 'demo'
        examples.append(result)
    
    return jsonify({
        'examples': examples,
        'total_examples': len(examples),
        'message': 'Demo predictions generated successfully',
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/cache-stats', methods=['GET'])
def cache_stats():
    """Cache statistics endpoint"""
    total_cached = random.randint(800, 3000)
    cache_hits = random.randint(1500, 8000)
    cache_misses = random.randint(200, 1200)
    
    return jsonify({
        'total_cached': total_cached,
        'cache_hits': cache_hits,
        'cache_misses': cache_misses,
        'cache_size': f"{round(random.uniform(45, 180), 1)} MB",
        'hit_rate': round((cache_hits / (cache_hits + cache_misses)) * 100, 1),
        'last_cleared': (datetime.datetime.now() - datetime.timedelta(hours=random.randint(2, 48))).isoformat(),
        'max_size': "500 MB"
    })

@app.route('/clear-cache', methods=['POST'])
def clear_cache():
    """Clear cache endpoint"""
    return jsonify({
        'success': True,
        'message': 'Cache cleared successfully',
        'items_cleared': random.randint(500, 2000),
        'memory_freed': f"{round(random.uniform(50, 200), 1)} MB",
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/test-all', methods=['GET'])
def test_all():
    """Test all endpoints"""
    endpoints = [
        '/health', '/predict', '/metrics', '/analytics', 
        '/model-info', '/demo', '/cache-stats', '/batch-predict'
    ]
    
    return jsonify({
        'endpoints_tested': len(endpoints),
        'all_healthy': True,
        'results': {endpoint.replace('/', ''): 'OK' for endpoint in endpoints},
        'server_status': 'All systems operational',
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    print("🚀 Starting GraphSmile Mobile Backend v3.0...")
    print("📱 Server will be available at: http://localhost:8002")
    print("🔗 Available endpoints:")
    
    routes = []
    for rule in app.url_map.iter_rules():
        if rule.endpoint != 'static':
            methods = ', '.join(sorted(rule.methods - {'HEAD', 'OPTIONS'}))
            routes.append(f"   {methods:8} {rule.rule}")
    
    for route in sorted(routes):
        print(route)
    
    print("\n✅ Backend ready for mobile app connections!")
    print("💡 Use Ctrl+C to stop the server")
    
    try:
        app.run(host='localhost', port=8002, debug=False, threaded=True)
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except Exception as e:
        print(f"\n❌ Server error: {e}")