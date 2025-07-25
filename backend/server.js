
const express = require('express');         // Import Express to create the server
const cors = require('cors');               // Allow cross-origin requests (for Flutter frontend)
const path = require('path');               // Import path module to handle file paths
const { spawn } = require('child_process'); // Used to run Python script from Node.js

const app = express();                    // Create an Express app
const PORT = 5001;                        // Set the port number for the server

app.use(cors());                          // Enable CORS so Flutter app can call this API
app.use(express.json());                 // Enable parsing JSON request body

// Define a root/health-check endpoint
app.get('/', (req, res) => {
    res.status(200).json({ status: 'ok', message: 'Emotion Detection API is running.' });
});

// Define POST endpoint for prediction
app.post('/predict', (req, res) => {
    const inputText = req.body.text;     // Get 'text' field from incoming JSON request

    if (!inputText) {
        return res.status(400).json({ error: 'No text provided' });
    }

    // Use path.join to create a robust, absolute path to the script
    const scriptPath = path.join(__dirname, 'predict.py');

    // Spawn a Python process to run 'predict.py' with the input text
    const python = spawn('python3', [scriptPath, inputText]);

    let data = '';                        // Variable to collect output from Python
    let errorData = '';                   // Variable to collect error output

    // Collect output from Python script (stdout)
    python.stdout.on('data', (chunk) => {
        data += chunk.toString();
    });

    // Collect error output from Python script (stderr)
    python.stderr.on('data', (err) => {
        errorData += err.toString();
    });

    // Handle errors in spawning the process itself (e.g., python3 not found)
    python.on('error', (err) => {
        console.error('Failed to start subprocess.', err);
        return res.status(500).json({ error: 'Prediction failed (subprocess error)' });
    });

    // When Python script ends, parse and send back the result
    python.on('close', (code) => {
        if (code !== 0) {
            console.error(`Python script exited with code ${code}`);
            console.error('Python stderr:', errorData);
            return res.status(500).json({ error: 'Prediction script failed.', details: errorData });
        }
        try {
            const result = JSON.parse(data);  // Parse the JSON output from Python
            res.json(result);                 // Send back to frontend
        } catch (e) {
            console.error('Error parsing Python output:', e);
            console.error('Python stdout:', data);
            // If something went wrong during parsing, return an error response
            res.status(500).json({ error: 'Prediction failed (parsing error)', details: data });
        }
    });
});

// Start the Express server and listen on the defined port
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${PORT}`);
});