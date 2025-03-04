import requests

# Flask API endpoint
url = "http://127.0.0.1:5000/predict"

# Sample input data
data = {
    "Age": 20,
    "BMI": 30,
    "UnusualBleeding": 1,
    "NumberofDaysofIntercourse": 0,
    "Breastfeeding": 0,
    "Numberpreg": 0
}

# Send POST request
response = requests.post(url, json=data)

# Print response
print("Response Status Code:", response.status_code)
print("Response JSON:", response.json())
