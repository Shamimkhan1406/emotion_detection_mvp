const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Emotion Detection API is running',
        timestamp: new Date().toISOString()
    });
});

// Main prediction endpoint
app.post('/predict', async (req, res) => {
    try {
        const { text } = req.body;

        // Validate input
        if (!text || typeof text !== 'string' || text.trim().length === 0) {
            return res.status(400).json({
                error: 'Invalid input: text is required and must be a non-empty string'
            });
        }

        // Sanitize text for command line
        const sanitizedText = text.replace(/"/g, '\\"').trim();

        // Call Python script
        const pythonScriptPath = path.join(__dirname, 'python_scripts', 'predict.py');
        
        const pythonProcess = spawn('python3', [pythonScriptPath, sanitizedText], {
            cwd: path.join(__dirname, 'python_scripts')
        });

        let output = '';
        let errorOutput = '';

        pythonProcess.stdout.on('data', (data) => {
            output += data.toString();
        });

        pythonProcess.stderr.on('data', (data) => {
            errorOutput += data.toString();
        });

        pythonProcess.on('close', (code) => {
            if (code !== 0) {
                console.error('Python script error:', errorOutput);
                return res.status(500).json({
                    error: 'Prediction failed',
                    details: errorOutput,
                    code: code
                });
            }

            try {
                const result = JSON.parse(output.trim());
                
                if (result.error) {
                    return res.status(500).json({
                        error: result.error
                    });
                }

                // Add metadata
                result.timestamp = new Date().toISOString();
                result.success = true;

                res.json(result);
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Python output:', output);
                res.status(500).json({
                    error: 'Failed to parse prediction result',
                    details: parseError.message
                });
            }
        });

        // Handle timeout (30 seconds)
        setTimeout(() => {
            pythonProcess.kill('SIGTERM');
            res.status(408).json({
                error: 'Prediction timeout - process took too long'
            });
        }, 30000);

    } catch (error) {
        console.error('Server error:', error);
        res.status(500).json({
            error: 'Internal server error',
            details: error.message
        });
    }
});

// Get emotion classes endpoint
app.get('/emotions', (req, res) => {
    const emotions = ['anger', 'disgust', 'fear', 'joy', 'neutral', 'sadness', 'shame', 'surprise'];
    res.json({
        emotions: emotions,
        count: emotions.length
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Endpoint not found',
        available_endpoints: [
            'GET /health',
            'POST /predict',
            'GET /emotions'
        ]
    });
});

// Error handler
app.use((error, req, res, next) => {
    console.error('Unhandled error:', error);
    res.status(500).json({
        error: 'Internal server error',
        message: error.message
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Emotion Detection API running on port ${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`🧠 Prediction endpoint: http://localhost:${PORT}/predict`);
    console.log(`😊 Emotions list: http://localhost:${PORT}/emotions`);
});

module.exports = app;