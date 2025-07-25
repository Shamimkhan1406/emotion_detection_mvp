#!/bin/bash

echo "🎨 Starting Flutter Web Frontend..."

cd frontend/emotion_detection_ui

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter and try again."
    echo "📖 Installation guide: https://docs.flutter.dev/get-started/install"
    echo ""
    echo "🔧 Alternative: You can run the frontend manually using:"
    echo "   1. Install Flutter SDK"
    echo "   2. Run: flutter pub get"
    echo "   3. Run: flutter run -d web-server --web-port 8080"
    exit 1
fi

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🌐 Starting Flutter web server on port 8080..."
flutter run -d web-server --web-port 8080