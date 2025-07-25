
import sys
import os
import joblib
import json
import numpy as np

# Load model
model_path = os.path.join(os.path.dirname(__file__), "emotion_detection.pkl")
model = joblib.load(model_path)

# Read input
text = sys.argv[1]

# Make prediction
prediction = model.predict([text])[0]
probabilities = model.predict_proba([text])[0]

# Get labels
labels = model.classes_

# Convert to dictionary
prob_dict = dict(zip(labels, probabilities))

# Final result
result = {
    "prediction": prediction,
    "probabilities": prob_dict
}

# ✅ Print as JSON
print(json.dumps(result))
