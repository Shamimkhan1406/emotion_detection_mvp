
import subprocess
import json
import ast


print("Test script started...")

def run_prediction(text):
    result = subprocess.run(
        ['python3', 'backend/predict.py', text],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    print("STDOUT:", result.stdout)   # ✅ print output
    print("STDERR:", result.stderr)   # ✅ print errors
    return result.stdout.strip()


def test_output_format():
    output = run_prediction("I am very happy today!")
    try:
        data = json.loads(output)
        assert 'prediction' in data
        assert 'probabilities' in data
        assert isinstance(data['probabilities'], dict)
        print("✅ Output format test passed.")
    except Exception as e:
        print("❌ Output format test failed:", e)

VALID_LABELS = ["anger", "disgust", "fear", "joy", "neutral", "sadness", "shame", "surprise"]

def test_valid_labels():
    output = run_prediction("I feel scared")
    data = json.loads(output)
    assert data['prediction'] in VALID_LABELS
    assert all(label in VALID_LABELS for label in data['probabilities'].keys())
    print("✅ Emotion labels test passed.")


def test_probability_sum():
    output = run_prediction("I'm feeling confused and uncertain.")
    data = json.loads(output)
    prob_sum = sum(data['probabilities'].values())
    assert 0.99 <= prob_sum <= 1.01
    print("✅ Probability sum test passed.")


def test_consistency():
    first = run_prediction("Life is beautiful")
    second = run_prediction("Life is beautiful")
    assert first == second
    print("✅ Consistency test passed.")


if __name__ == "__main__":
    test_output_format()
    test_valid_labels()
    test_probability_sum()
    test_consistency()
