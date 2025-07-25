# 🚀 Quick Start Guide - Emotion Detection Web App

## ⚡ Get Running in 5 Minutes

### 1. Install Dependencies
```bash
# Navigate to project
cd emotion-detection-app

# Install Node.js packages
cd backend && npm install && cd ..

# Install Python packages
pip3 install neattext scikit-learn joblib numpy pandas --break-system-packages
```

### 2. Start Backend (Terminal 1)
```bash
cd backend
node server.js
```

You should see:
```
🚀 Emotion Detection API running on port 3000
📊 Health check: http://localhost:3000/health
🧠 Prediction endpoint: http://localhost:3000/predict
😊 Emotions list: http://localhost:3000/emotions
```

### 3. Test the API
```bash
# In a new terminal
curl -X POST http://localhost:3000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "I am feeling amazing today!"}'
```

### 4. Start Frontend (Terminal 2)
```bash
# If you have Flutter installed:
cd frontend/emotion_detection_ui
flutter pub get
flutter run -d web-server --web-port 8080

# Access at: http://localhost:8080
```

## 🧪 Test Everything Works

Run the automated test:
```bash
cd backend
node test_api.js
```

## 📱 Frontend Features

The Flutter web app includes:
- **Text Input Field**: Enter any text to analyze
- **Emotion Prediction**: Shows the detected emotion
- **Probability Bar Chart**: Visual representation of all emotion probabilities
- **Responsive Design**: Works on desktop and mobile browsers
- **Real-time Results**: Instant predictions via API calls

## 🎯 API Usage Examples

### Health Check
```bash
curl http://localhost:3000/health
```

### Emotion Prediction
```bash
curl -X POST http://localhost:3000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "Your text here"}'
```

### Get Available Emotions
```bash
curl http://localhost:3000/emotions
```

## 🔧 Troubleshooting

**Server won't start?**
- Check if port 3000 is free: `lsof -i :3000`
- Kill existing process: `lsof -ti:3000 | xargs kill`

**Python errors?**
- Install missing packages: `pip3 install neattext scikit-learn joblib`
- Check Python version: `python3 --version` (need 3.8+)

**Model not found?**
- Verify file exists: `ls -la backend/models/emotion_detection.pkl`
- Copy your model: `cp your_model.pkl backend/models/emotion_detection.pkl`

**Flutter issues?**
- Install Flutter: https://docs.flutter.dev/get-started/install
- Enable web: `flutter config --enable-web`

## 🌟 What's Included

### Backend (Node.js + Express)
- ✅ RESTful API with CORS enabled
- ✅ Python ML model integration
- ✅ Error handling and validation
- ✅ JSON response format
- ✅ Health monitoring

### ML Integration (Python)
- ✅ Model loading with joblib
- ✅ Text preprocessing (same as training)
- ✅ 8 emotion classes prediction
- ✅ Probability scores for all emotions
- ✅ JSON output format

### Frontend (Flutter Web)
- ✅ Modern, responsive UI design
- ✅ Real-time text analysis
- ✅ Interactive bar charts (fl_chart)
- ✅ Error handling and loading states
- ✅ Mobile-friendly interface

## 🚀 Production Ready Features

- **Security**: Input validation and sanitization
- **Performance**: Efficient model loading and prediction
- **Monitoring**: Health checks and API status
- **Scalability**: Stateless design for easy scaling
- **Documentation**: Complete API documentation
- **Testing**: Automated test suite included

---

**Need more help?** Check the full `DEPLOYMENT_GUIDE.md` for detailed instructions and troubleshooting!