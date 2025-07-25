#!/usr/bin/env python3
import sys
import json
import joblib
import numpy as np
import neattext.functions as nfx
from sklearn.pipeline import Pipeline
import warnings
warnings.filterwarnings('ignore')

# Define emotion classes based on your dataset
EMOTION_CLASSES = ['anger', 'disgust', 'fear', 'joy', 'neutral', 'sadness', 'shame', 'surprise']

def preprocess_text(text):
    """Preprocess text similar to training data"""
    # Remove user handles
    clean_text = nfx.remove_userhandles(text)
    # Remove stopwords
    clean_text = nfx.remove_stopwords(clean_text)
    return clean_text

def load_model():
    """Load the trained emotion detection model"""
    try:
        model_path = '../models/emotion_detection.pkl'
        model = joblib.load(model_path)
        return model
    except Exception as e:
        print(f"Error loading model: {str(e)}", file=sys.stderr)
        return None

def predict_emotion(text, model):
    """Predict emotion from text"""
    try:
        # Preprocess the input text
        clean_text = preprocess_text(text)
        
        # Make prediction
        prediction = model.predict([clean_text])[0]
        
        # Get prediction probabilities
        probabilities = model.predict_proba([clean_text])[0]
        
        # Create probability dictionary
        prob_dict = {}
        for i, emotion in enumerate(model.classes_):
            prob_dict[emotion] = float(probabilities[i])
        
        return {
            'predicted_emotion': prediction,
            'probabilities': prob_dict,
            'original_text': text,
            'processed_text': clean_text
        }
    except Exception as e:
        return {
            'error': f"Prediction error: {str(e)}"
        }

def main():
    """Main function to handle command line input"""
    if len(sys.argv) != 2:
        print(json.dumps({'error': 'Please provide text as argument'}))
        sys.exit(1)
    
    input_text = sys.argv[1]
    
    # Load model
    model = load_model()
    if model is None:
        print(json.dumps({'error': 'Failed to load model'}))
        sys.exit(1)
    
    # Make prediction
    result = predict_emotion(input_text, model)
    
    # Output result as JSON
    print(json.dumps(result))

if __name__ == "__main__":
    main()