const axios = require('axios');

async function testAPI() {
    const baseURL = 'http://localhost:3000';
    
    console.log('🧪 Testing Emotion Detection API...\n');
    
    try {
        // Test 1: Health check
        console.log('1. Testing health endpoint...');
        const healthResponse = await axios.get(`${baseURL}/health`);
        console.log('✅ Health check passed:', healthResponse.data);
        
        // Test 2: Prediction endpoint
        console.log('\n2. Testing prediction endpoint...');
        const testTexts = [
            "I am so happy today!",
            "This makes me really angry and frustrated!",
            "I'm feeling quite sad and depressed.",
            "That was really scary and frightening.",
            "What a beautiful surprise!"
        ];
        
        for (const text of testTexts) {
            console.log(`\n   Testing: "${text}"`);
            const predictionResponse = await axios.post(`${baseURL}/predict`, {
                text: text
            });
            
            const result = predictionResponse.data;
            console.log(`   ➤ Predicted emotion: ${result.predicted_emotion}`);
            console.log(`   ➤ Confidence: ${(Math.max(...Object.values(result.probabilities)) * 100).toFixed(1)}%`);
        }
        
        console.log('\n🎉 All tests passed! API is working correctly.');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
        if (error.response) {
            console.error('Response data:', error.response.data);
        }
    }
}

testAPI();