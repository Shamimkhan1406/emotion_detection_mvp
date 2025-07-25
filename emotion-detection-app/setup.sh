#!/bin/bash

echo "🚀 Setting up Emotion Detection Web Application..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
print_status "Checking prerequisites..."

# Check Python
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3.8+ and try again."
    exit 1
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 16+ and try again."
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm and try again."
    exit 1
fi

print_status "All prerequisites found!"

# Setup Python environment
print_status "Setting up Python environment..."
cd backend/python_scripts

if [ -f "requirements.txt" ]; then
    print_status "Installing Python dependencies..."
    pip3 install -r requirements.txt
    if [ $? -eq 0 ]; then
        print_status "Python dependencies installed successfully!"
    else
        print_error "Failed to install Python dependencies"
        exit 1
    fi
else
    print_warning "requirements.txt not found in python_scripts directory"
fi

# Test Python script
print_status "Testing Python prediction script..."
python3 predict.py "I am very happy today!" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "Python script is working correctly!"
else
    print_warning "Python script test failed. Check dependencies."
fi

cd ../..

# Setup Node.js backend
print_status "Setting up Node.js backend..."
cd backend

if [ -f "package.json" ]; then
    print_status "Installing Node.js dependencies..."
    npm install
    if [ $? -eq 0 ]; then
        print_status "Node.js dependencies installed successfully!"
    else
        print_error "Failed to install Node.js dependencies"
        exit 1
    fi
else
    print_error "package.json not found in backend directory"
    exit 1
fi

cd ..

# Setup Flutter frontend (if Flutter is available)
print_status "Setting up Flutter frontend..."
cd frontend/emotion_detection_ui

if command -v flutter &> /dev/null; then
    print_status "Flutter found! Installing Flutter dependencies..."
    flutter pub get
    if [ $? -eq 0 ]; then
        print_status "Flutter dependencies installed successfully!"
    else
        print_warning "Failed to install Flutter dependencies"
    fi
else
    print_warning "Flutter not found. You'll need to install Flutter SDK to run the frontend."
    print_warning "Visit: https://flutter.dev/docs/get-started/install"
fi

cd ../..

# Create start scripts
print_status "Creating start scripts..."

# Backend start script
cat > start_backend.sh << 'EOF'
#!/bin/bash
echo "🔧 Starting Emotion Detection Backend..."
cd backend
npm start
EOF

# Frontend start script (if Flutter is available)
if command -v flutter &> /dev/null; then
    cat > start_frontend.sh << 'EOF'
#!/bin/bash
echo "🎨 Starting Emotion Detection Frontend..."
cd frontend/emotion_detection_ui
flutter run -d web-server --web-port 8080
EOF
else
    cat > start_frontend.sh << 'EOF'
#!/bin/bash
echo "❌ Flutter not found!"
echo "Please install Flutter SDK from: https://flutter.dev/docs/get-started/install"
echo "Then run: flutter run -d web-server --web-port 8080"
EOF
fi

# Make scripts executable
chmod +x start_backend.sh
chmod +x start_frontend.sh

# Summary
print_status "Setup completed successfully! 🎉"
echo ""
echo "📋 Next Steps:"
echo "1. Start the backend server:"
echo "   ./start_backend.sh"
echo "   (or manually: cd backend && npm start)"
echo ""
echo "2. In a new terminal, start the frontend:"
echo "   ./start_frontend.sh"
echo "   (or manually: cd frontend/emotion_detection_ui && flutter run -d web-server --web-port 8080)"
echo ""
echo "3. Open your browser and navigate to:"
echo "   Frontend: http://localhost:8080"
echo "   Backend API: http://localhost:3000/health"
echo ""
echo "🔧 Troubleshooting:"
echo "- If you get permission errors, run: chmod +x setup.sh"
echo "- For Python issues, check: pip3 install -r backend/python_scripts/requirements.txt"
echo "- For Node.js issues, check: cd backend && npm install"
echo "- For Flutter issues, check: cd frontend/emotion_detection_ui && flutter pub get"
echo ""
print_status "Happy coding! 😊"