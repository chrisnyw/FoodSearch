# FoodSearch
This project showcases how to integrate Apple’s App Intents API with the Apple Testing framework to create feature-rich, testable iOS applications.

## Introduction
### Basic Functions
This app allows users to input three parameters: food name, a calorie comparison (more/less than), and a calorie limit. It then queries the Nutritionix API to retrieve a list of available foods that match the criteria.

Users can tap on a food item from the list to view detailed nutritional information. Additionally, the app fetches nearby restaurant locations using data from the open-source endpoint nominatim.openstreetmap.org and displays them at the bottom of the screen.

### App Intent
In addition to the core features, this app primarily demonstrates how to integrate the App Intent framework with SiriKit and Apple Intelligence to enhance app functionality.

## App Screenshots
<figure>
<img src="https://github.com/user-attachments/assets/ab4e2f80-db58-483d-8194-452b023fc383" width="200" title="App Demo 1" alt="App Demo 1"/>
<img src="https://github.com/user-attachments/assets/151e33a4-befb-43ea-9897-b8c43c12aeeb" width="200" title="App Demo 2" alt="App Demo 2"/>
<img src="https://github.com/user-attachments/assets/18589279-2506-4a75-99b8-b89d9267b5a8" width="200" title="App Demo 3" alt="App Demo 3"/>
</figure>

## Credits

This project uses the following third-party packages and APIs:
- [Nutritionix API](https://www.nutritionix.com) – For retrieving food nutrition data.
- [Nominatim (OpenStreetMap)](https://nominatim.openstreetmap.org/) – For finding nearby restaurants.
- [Clean Architecture for SwiftUI](https://github.com/nalexn/clean-architecture-swiftui) - SwiftUI app architecture reference.
- [SwiftLocation](https://github.com/malcommac/SwiftLocation) - Retrieve and manage location updates in asyn/await
- [ViewInspector](https://github.com/nalexn/ViewInspector) - Library for unit testing SwiftUI views

A big thank you to the developers and communities! 🎉

## Documentation
[App Intent Guide](Documents/AppIntent.md)

[Swift Testing Guide](Documents/SwiftTesting.md)