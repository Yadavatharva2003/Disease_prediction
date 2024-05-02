from flask import Flask, request, jsonify
from joblib import load
import pandas as pd

app = Flask(__name__)

# Load the first model
model1 = load('./model1.joblib')

# Load the second model
model2 = load('./model2.joblib')

@app.route('/predict_model1', methods=['POST'])
def predict_model1():
    # Get the JSON data from the request
    data = request.get_json()
    input_data = pd.DataFrame(data)

    # Perform prediction using the first model
    prediction = model1.predict(input_data)

    # Decode the prediction if needed
    # prediction = le.inverse_transform(prediction)

    # Return the prediction as JSON
    return jsonify({'prediction': prediction.tolist()})

@app.route('/predict_model2', methods=['POST'])
def predict_model2():
    # Get the JSON data from the request
    data = request.get_json()
    input_data = pd.DataFrame(data)

    # Perform prediction using the second model
    prediction = model2.predict(input_data)

    # Decode the prediction if needed
    # prediction = label_encoder.inverse_transform(prediction)

    # Return the prediction as JSON
    return jsonify({'prediction': prediction.tolist()})

if __name__ == '__main__':
    app.run(debug=True)
