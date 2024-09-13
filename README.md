# 🌱 Vext App:
vext creates fridges for plants to grow in the most efficient way possible by providing them with the lighting and nutrients they need. This app helps users manage these smart fridges to ensure their plants grow healthy and strong

## 👩🏽‍🍳 Features
- **authentication**: handle user authentication using Supabase for secure access to app.
- **lighting control**: adjust the lighting in your fridge to fit your plant's needs.
- **nutrient management**: set nutrient levels based on the size and type of your plants.
- **planting guides**: get tips for planting various vegetables and fruits.
- **to-do list**: keep track of tasks like cleaning the fridge or refilling the water tank.

## 📸 Screenshots
<div style="display: flex; flex-wrap: wrap;">
  <img src="https://github.com/user-attachments/assets/12039585-8724-45ce-bc3b-daa3c1b8c502" alt="Screenshot 1" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/5164d43c-7ab5-4984-aa20-ad023bab97d2" alt="Screenshot 2" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/b899044c-196b-4afa-a955-a652081ee54a" alt="Screenshot 3" width="200" style="margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/d6fd32dc-8a00-41ea-8c73-8e6f3fdb0c95" alt="Screenshot 4" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/4083d59d-2573-44bd-b59c-eb99b079a1fc" alt="Screenshot 5" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/ae9b5c08-1d6a-42ec-b578-64cc3670887c" alt="Screenshot 6" width="200" style="margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/4435da73-951b-4eb1-ac39-cda1733dfdb3" alt="Screenshot 7" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/8f7e972a-8e42-4d68-ac07-ae180a749a60" alt="Screenshot 8" width="200" style="margin-right: 10px; margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/c6ee260b-aaf1-4200-be18-cf0dc1be9d61" alt="Screenshot 9" width="200" style="margin-bottom: 10px;">
  <img src="https://github.com/user-attachments/assets/dafa2be4-960f-4b21-835e-d639f5771c56" alt="Screenshot 10" width="200" style="margin-right: 10px; margin-bottom: 10px;">
</div>

## 📊 Data Fetching from ThingsBoard
this app fetches data from ThingsBoard using 2 methods:
1. **Telemetry:** real-time values that update every 10 seconds. these values are used to display live data from the smart fridges, such as current temperature, humidity, and nutrient levels.
   
2. **Attributes:** normal values that are fetched once when the app starts or when needed. these values represent static data about the smart fridges, such as device information, settings, and user preferences.

## 🛠️ Getting Started
### Prerequisites
- Flutter SDK: [Install Flutter](https://docs.flutter.dev/get-started/install)
- Thingsboard account & credentials 

### Installation
1. **clone this repo**:
```sh
git clone https://github.com/fatihmerickoc/vext_app.git
cd vext-fridge-app
```
2. **install dependencies**
```sh
flutter pub get
```

3. **run the app**
```sh
flutter run
```
## 📦 Built With
[Flutter](https://flutter.dev/) ~ the mobile framework

[Supabase](https://supabase.com/) ~ open source Firebase alternative

[ThingsBoard](https://thingsboard.io/) ~  IoT platform for device management

[Riverpod](https://riverpod.dev/) ~ state management library

## 📜 License:
© 2024 Fatih Koc. All rights reserved. This code is the proprietary property of Fatih Koc / Vext Oy. No part of this repository may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the owner, except for brief quotations in critical reviews and certain noncommercial uses permitted by copyright law. Usage for commercial purposes or within company settings is explicitly prohibited.












