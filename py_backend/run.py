import joblib
import pandas as pd
import numpy as np

# Load the ARIMA model
model_filename = 'arima_menstrual_cycle_model_simple.pkl'  # Ensure the correct model path
arima_model = joblib.load(model_filename)

# Load the scaler used during training
scaler = joblib.load('scaler.pkl')  # Ensure the correct scaler path

# Function to predict the menstrual cycle length based on user input
def predict_cycle_length(user_input, scaler=None):
    # Remove 'CycleNumber' from user input (it's not a feature for prediction)
    user_data = pd.DataFrame([user_input])

    # Ensure the user input matches the training data format (only features, no 'CycleNumber')
    user_data = user_data[['Age', 'BMI', 'UnusualBleeding', 'NumberofDaysofIntercourse', 'Breastfeeding', 'Numberpreg']]

    # Clean the input data (ensure all values are numeric)
    user_data = user_data.apply(pd.to_numeric, errors='coerce')
    user_data.fillna(user_data.median(), inplace=True)

    # If scaling was used during training, apply the scaler to the input data
    if scaler:
        user_data_scaled = scaler.transform(user_data)  # Use transform instead of fit_transform
    else:
        user_data_scaled = user_data  # If no scaling was done during training, use raw input data
    
    # Debug: Print the user data and scaled data
    print("User Input Data:\n", user_data)
    print("Scaled User Data:\n", user_data_scaled)
    
    # Make a prediction using the ARIMAX model (ensure external variables are included)
    predicted_value = arima_model.predict(start=0, end=0, exog=user_data_scaled)
    
    # Return the predicted cycle length
    return predicted_value[0]  # Access the first value of the prediction

# Example user input (replace with actual inputs)
user_input = {
    'CycleNumber': 1,  # for example, 100th cycle (this will be removed during preprocessing)
    'Age': 20,
    'BMI': 25.5,
    'UnusualBleeding': 0,  # Example binary input: 0 = No, 1 = Yes
    'NumberofDaysofIntercourse': 0,  # Example numerical input
    'Breastfeeding': 0,  # Example binary input: 0 = No, 1 = Yes
    'Numberpreg': 0  # Example input
}

# Call the function with the user input
predicted_cycle_length = predict_cycle_length(user_input, scaler)

# Print the predicted cycle length
print("Predicted Menstrual Cycle Length (Days):", predicted_cycle_length)
