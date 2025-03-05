from flask import Flask, request, jsonify
import pickle
import pandas as pd
import numpy as np
from statsmodels.tsa.arima.model import ARIMA

# Load trained ARIMA model
with open("iterative_arima_model_with_bmi.pkl", "rb") as file:
    arima_model = pickle.load(file)

# Flask app
app = Flask(__name__)

# Store historical data (to maintain iterative updates)
history_target = list(arima_model.model.endog)
history_exog = np.array(arima_model.model.exog)  # Ensure this is a NumPy array

@app.route("/predict", methods=["POST"])
def predict():
    global history_target, history_exog, arima_model  # Keep updating

    try:
        # Get JSON data from user
        data = request.get_json()

        # Expected feature columns
        exog_columns = ['Age', 'BMI', 'UnusualBleeding', 'NumberofDaysofIntercourse', 'Breastfeeding', 'Numberpreg']

        # Convert JSON to DataFrame
        user_input = pd.DataFrame([data])

        # Ensure all inputs are numeric
        user_input = user_input[exog_columns].apply(pd.to_numeric, errors='coerce')

        # Handle missing values (fill with median)
        user_input.fillna(user_input.median(), inplace=True)

        # Convert to NumPy array
        user_exog = user_input.values.reshape(1, -1)  # Ensuring correct shape (1, features)

        # Predict next cycle length
        prediction = arima_model.forecast(steps=1, exog=user_exog)[0]
        
        # Debugging
        print(f"User Input: {user_input.to_dict(orient='records')}")
        print(f"Predicted Cycle Length: {prediction}")

        # # Append to history
        # history_target.append(prediction)
        # history_exog = np.vstack((history_exog, user_exog))  # Stack new exog values correctly

        # # Retrain ARIMA dynamically
        # arima_model = ARIMA(history_target, exog=history_exog, order=(2, 0, 2)).fit()

        # Return response
        return jsonify({"predicted_cycle_length": int(round(prediction, 0))})

    except Exception as e:
        print(f"Prediction error: {str(e)}")  # Debugging logs
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    # app.run(host="127.0.0.1", port=5000, debug=True)
    app.run(host="0.0.0.0", port=5000, debug=True)
