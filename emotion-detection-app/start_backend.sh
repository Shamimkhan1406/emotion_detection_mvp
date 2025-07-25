#!/bin/bash

echo "🚀 Starting Emotion Detection Backend Server..."

cd backend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

# Check if Python dependencies are installed
echo "🐍 Checking Python dependencies..."
python3 -c "import neattext, joblib, sklearn" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "📦 Installing Python dependencies..."
    pip3 install neattext scikit-learn joblib numpy pandas --break-system-packages
fi

echo "🎯 Starting server on port 3000..."
node server.js