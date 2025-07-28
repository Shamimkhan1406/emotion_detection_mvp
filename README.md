# 🎭 Emotion Detection Application

A sophisticated full-stack application that analyzes text input and predicts emotions using machine learning. The application features a beautiful Flutter mobile interface and a robust Node.js backend with Python ML integration.

## 🌟 Features

- **Real-time Emotion Detection**: Analyzes text and predicts emotions with confidence scores
- **8 Emotion Categories**: Detects anger, disgust, fear, joy, neutral, sadness, shame, and surprise
- **Interactive Visualization**: Beautiful charts showing probability distributions for each emotion
- **Cross-platform Mobile App**: Flutter-based mobile application for iOS and Android
- **RESTful API**: Clean Node.js backend with Express.js framework
- **Machine Learning Pipeline**: Scikit-learn based classification with CountVectorizer and Logistic Regression
- **Comprehensive Testing**: Automated tests for model consistency and accuracy

## 🏗️ Architecture

```
┌─────────────────┐    HTTP     ┌─────────────────┐    Python    ┌─────────────────┐
│   Flutter App   │ ──────────► │   Node.js API   │ ───────────► │   ML Model      │
│   (Frontend)    │             │   (Backend)     │              │   (Python)      │
└─────────────────┘             └─────────────────┘              └─────────────────┘
```

## 🚀 Technologies Used

### Frontend (Flutter)
- **Framework**: Flutter (Dart)
- **HTTP Client**: http package for API communication
- **Charts**: fl_chart for emotion probability visualization
- **UI**: Material Design components

### Backend (Node.js)
- **Runtime**: Node.js with Express.js
- **CORS**: Cross-origin resource sharing enabled
- **Process Management**: Child process for Python integration

### Machine Learning (Python)
- **Framework**: Scikit-learn
- **Algorithm**: Logistic Regression with CountVectorizer
- **Text Processing**: NeatText for preprocessing
- **Data Analysis**: Pandas, NumPy, Seaborn
- **Model Persistence**: Joblib for model serialization

## 📦 Installation & Setup

### Prerequisites
- Python 3.7+
- Node.js 14+
- Flutter SDK 3.7+
- Git

### 1. Clone the Repository
```bash
git clone <repository-url>
cd emotion-detection-app
```

### 2. Backend Setup
```bash
# Navigate to backend directory
cd backend

# Install Node.js dependencies
npm install

# Install Python dependencies (from root directory)
cd ..
pip install -r requirements.txt
```

### 3. Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Run the app (make sure you have an emulator running or device connected)
flutter run
```

### 4. Start the Backend Server
```bash
# From the backend directory
cd backend
node server.js
```

The server will start on `http://localhost:5001`

## 🎯 Usage

1. **Start the Backend**: Run the Node.js server using `node server.js`
2. **Launch the App**: Use `flutter run` to start the mobile application
3. **Enter Text**: Type any text in the input field
4. **Get Prediction**: Tap the "Predict Emotion" button
5. **View Results**: See the predicted emotion and probability chart

### Example API Usage
```bash
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "I am feeling great today!"}'
```

Response:
```json
{
  "prediction": "joy",
  "probabilities": {
    "anger": 0.05,
    "disgust": 0.02,
    "fear": 0.03,
    "joy": 0.78,
    "neutral": 0.08,
    "sadness": 0.02,
    "shame": 0.01,
    "surprise": 0.01
  }
}
```

## 🧪 Testing

Run the comprehensive test suite to validate model performance:

```bash
# Run all tests
python test_predict.py
```

The test suite validates:
- ✅ JSON output format
- ✅ Valid emotion labels
- ✅ Probability distribution (sums to 1.0)
- ✅ Model consistency

## 📊 Model Performance

The emotion detection model uses:
- **Algorithm**: Logistic Regression
- **Vectorization**: CountVectorizer for text feature extraction
- **Training Split**: 70% training, 30% testing
- **Text Preprocessing**: Stopword removal, user handle cleaning
- **Emotion Classes**: 8 distinct emotional categories

## 📁 Project Structure

```
emotion-detection-app/
├── 📱 frontend/                 # Flutter mobile application
│   ├── lib/
│   │   └── main.dart           # Main app logic and UI
│   ├── pubspec.yaml            # Flutter dependencies
│   └── README.md               # Flutter-specific documentation
├── 🔙 backend/                  # Node.js API server
│   ├── server.js               # Express server setup
│   ├── predict.py              # Python ML prediction script
│   ├── emotion_detection.pkl   # Trained ML model
│   └── package.json            # Node.js dependencies
├── 🧠 ML Development/
│   ├── emotion_detection_model.ipynb  # Model training notebook
│   ├── emotion_dataset.csv     # Training dataset
│   └── emotion_detection_2.pkl # Alternative model version
├── 🧪 Testing/
│   └── test_predict.py         # Automated test suite
└── 📋 Configuration/
    ├── requirements.txt        # Python dependencies
    ├── .gitignore             # Git ignore rules
    └── README.md              # This file
```

## 🔧 API Endpoints

### `GET /`
Health check endpoint
- **Response**: `{"status": "ok", "message": "Emotion Detection API is running."}`

### `POST /predict`
Emotion prediction endpoint
- **Request Body**: `{"text": "your text here"}`
- **Response**: `{"prediction": "emotion", "probabilities": {...}}`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Development Notes

### Model Training
The ML model was trained using a comprehensive emotion dataset with the following preprocessing steps:
1. User handle removal
2. Stopword elimination
3. Text vectorization using CountVectorizer
4. Logistic Regression classification

### Frontend Architecture
The Flutter app follows a stateful widget pattern with:
- HTTP client for API communication
- Real-time chart updates
- Material Design UI components
- Cross-platform compatibility

### Backend Design
The Node.js backend implements:
- RESTful API design
- Python process spawning for ML inference
- CORS support for cross-origin requests
- Comprehensive error handling

## 🐛 Troubleshooting

### Common Issues

1. **Python Script Not Found**
   - Ensure Python is installed and accessible via `python3`
   - Verify the predict.py script exists in the backend directory

2. **Model File Missing**
   - Check that `emotion_detection.pkl` exists in the backend directory
   - Re-run the Jupyter notebook to regenerate the model if needed

3. **Flutter Build Issues**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is properly installed

4. **CORS Errors**
   - Verify the backend server is running on port 5001
   - Check that CORS middleware is properly configured

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Scikit-learn team for the machine learning framework
- Flutter team for the cross-platform mobile framework
- Express.js community for the web framework
- Contributors to the emotion dataset

---

**Made with ❤️ for emotion analysis and understanding**