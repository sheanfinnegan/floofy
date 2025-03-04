import joblib
import pandas as pd
import matplotlib.pyplot as plt

# Load the ARIMA model
model_filename = 'arima_menstrual_cycle_model.pkl'
arima_model = joblib.load(model_filename)

# Assuming you have the data in the correct format
# Load your dataset (replace this with the actual path to your dataset)
data = pd.read_csv('dataset/data.csv')

# Prepare the data (ensure the format is similar to the one used during training)
cycle_data = data[['CycleNumber', 'LengthofCycle']].dropna()
cycle_data.set_index('CycleNumber', inplace=True)

# Forecast future values (for example, forecast the next 10 cycles)
forecast_steps = 10
forecast = arima_model.forecast(steps=forecast_steps)

# Display the forecasted values
print("Forecasted Length of Cycles for next 10 periods:")
print(forecast)

# Plot the original data and the forecast
plt.figure(figsize=(10, 6))
plt.plot(cycle_data.index, cycle_data['LengthofCycle'], label='Original Data')
plt.plot(range(cycle_data.index[-1] + 1, cycle_data.index[-1] + forecast_steps + 1), forecast, label='Forecast', color='red')
plt.title('Menstrual Cycle Length Forecast')
plt.xlabel('Cycle Number')
plt.ylabel('Length of Cycle (Days)')
plt.legend()
plt.show()
