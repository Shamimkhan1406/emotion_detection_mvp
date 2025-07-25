# Emotion Detection Web Application

A complete web application for detecting human emotions from text using Machine Learning. Built with Flutter Web frontend, Node.js/Express backend, and Python ML model integration.

## Architecture

```
emotion-detection-app/
├── backend/
│   ├── models/
│   │   └── emotion_detection.pkl    # Your trained ML model
│   ├── python_scripts/
│   │   ├── predict.py              # Python prediction script
│   │   └── requirements.txt        # Python dependencies
│   ├── package.json                # Node.js dependencies
│   └── server.js                   # Express.js API server
├── frontend/
│   └── emotion_detection_ui/
│       ├── lib/
│       │   └── main.dart           # Flutter main app
│       ├── web/
│       │   └── index.html          # Web configuration
│       └── pubspec.yaml            # Flutter dependencies
└── README.md
```

## Features

- **Text Input**: Simple and intuitive text input interface
- **Real-time Prediction**: Get emotion predictions with ~62% accuracy
- **Visual Results**: Beautiful bar chart showing probability distribution
- **8 Emotion Classes**: joy, sadness, fear, anger, surprise, neutral, disgust, shame
- **Responsive Design**: Works on desktop and mobile browsers
- **Error Handling**: Comprehensive error handling and user feedback

## Prerequisites

Make sure you have the following installed:

1. **Python 3.8+** with pip
2. **Node.js 16+** with npm
3. **Flutter 3.10+** (for development)

## Step-by-Step Setup Guide

### Step 1: Set Up Python Environment

```bash
# Navigate to the python scripts directory
cd emotion-detection-app/backend/python_scripts

# Install Python dependencies
pip install -r requirements.txt

# Test the prediction script
python3 predict.py "I am very happy today!"
```

Expected output:
```json
{
  "predicted_emotion": "joy",
  "probabilities": {
    "joy": 0.85,
    "sadness": 0.05,
    "anger": 0.03,
    ...
  },
  "original_text": "I am very happy today!",
  "processed_text": "happy today"
}
```

### Step 2: Set Up Node.js Backend

```bash
# Navigate to backend directory
cd emotion-detection-app/backend

# Install Node.js dependencies
npm install

# Start the backend server
npm start
```

The server will start on `http://localhost:3000`

**Test the API endpoints:**

1. Health check: `GET http://localhost:3000/health`
2. Prediction: `POST http://localhost:3000/predict`
   ```json
   {
     "text": "I am feeling great today!"
   }
   ```
3. Emotions list: `GET http://localhost:3000/emotions`

### Step 3: Set Up Flutter Frontend

```bash
# Navigate to Flutter project
cd emotion-detection-app/frontend/emotion_detection_ui

# Get Flutter dependencies
flutter pub get

# Run the web app in development mode
flutter run -d web-server --web-port 8080
```

The Flutter app will be available at `http://localhost:8080`

### Step 4: Test the Complete Application

1. **Open the Flutter web app** in your browser: `http://localhost:8080`
2. **Enter some text** in the input field (e.g., "I'm so excited about this project!")
3. **Click "Predict Emotion"**
4. **View the results:**
   - Original text display
   - Predicted emotion with color coding
   - Interactive bar chart showing all emotion probabilities

## API Documentation

### Backend Endpoints

#### `GET /health`
Returns server health status.

**Response:**
```json
{
  "status": "OK",
  "message": "Emotion Detection API is running",
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

#### `POST /predict`
Predicts emotion from input text.

**Request Body:**
```json
{
  "text": "Your text here"
}
```

**Response:**
```json
{
  "predicted_emotion": "joy",
  "probabilities": {
    "anger": 0.02,
    "disgust": 0.01,
    "fear": 0.05,
    "joy": 0.82,
    "neutral": 0.03,
    "sadness": 0.04,
    "shame": 0.01,
    "surprise": 0.02
  },
  "original_text": "Your text here",
  "processed_text": "processed text",
  "timestamp": "2024-01-01T12:00:00.000Z",
  "success": true
}
```

#### `GET /emotions`
Returns list of available emotion classes.

**Response:**
```json
{
  "emotions": ["anger", "disgust", "fear", "joy", "neutral", "sadness", "shame", "surprise"],
  "count": 8
}
```

## Development Guide

### Adding New Features

1. **Backend modifications**: Edit `backend/server.js`
2. **ML model updates**: Replace `backend/models/emotion_detection.pkl` and update `python_scripts/predict.py`
3. **Frontend changes**: Modify `frontend/emotion_detection_ui/lib/main.dart`

### CORS Configuration

The backend is configured to accept requests from any origin for development. For production:

```javascript
// In server.js, replace:
app.use(cors());

// With:
app.use(cors({
  origin: ['http://your-flutter-domain.com'],
  credentials: true
}));
```

### Environment Variables

Create a `.env` file in the backend directory:

```env
PORT=3000
PYTHON_PATH=/usr/bin/python3
MODEL_PATH=./models/emotion_detection.pkl
```

## Troubleshooting

### Common Issues

1. **"Module not found" errors in Python:**
   ```bash
   pip install --upgrade scikit-learn pandas numpy joblib neattext
   ```

2. **CORS errors in browser:**
   - Ensure backend server is running
   - Check that frontend is making requests to correct URL

3. **Flutter build errors:**
   ```bash
   flutter clean
   flutter pub get
   flutter pub upgrade
   ```

4. **Python script timeout:**
   - Increase timeout in `server.js` (line with `setTimeout`)
   - Check model file path and permissions

### Performance Optimization

1. **Model Loading**: The Python script loads the model on each request. For production, consider:
   - Keeping a persistent Python process
   - Using a faster model format (ONNX, TensorFlow Lite)
   - Implementing model caching

2. **Frontend Optimization**:
   - Build for production: `flutter build web`
   - Enable web renderer: `flutter build web --web-renderer canvaskit`

## Production Deployment

### Backend Deployment

```bash
# Build for production
npm install --production

# Use PM2 for process management
npm install -g pm2
pm2 start server.js --name emotion-api

# Set up reverse proxy with nginx
```

### Frontend Deployment

```bash
# Build Flutter web app
flutter build web --release

# Deploy build/web directory to your web server
# (e.g., Netlify, Vercel, Firebase Hosting)
```

## Model Information

- **Algorithm**: Logistic Regression with CountVectorizer
- **Accuracy**: ~62%
- **Input**: Raw text string
- **Output**: 8 emotion classes with probabilities
- **Preprocessing**: Removes user handles and stopwords

## License

This project is open source and available under the MIT License.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review the API documentation
3. Create an issue in the repository