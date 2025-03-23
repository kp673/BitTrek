# BitTrek

BitTrek is a cryptocurrency portfolio tracker app designed to provide live cryptocurrency data, seamless user interaction, and efficient state management. This app is built using modern iOS development principles, adhering to the latest Swift 6 rules, concurrency standards, and thread-safe practices.

---

## Features

- **Cryptocurrency Data**: On-Demand updates fetched from the [CoinGecko API](https://www.coingecko.com/en).
- **Portfolio Tracking**: Track your cryptocurrency portfolio with ease and view insights into your holdings.
- **Core Data Integration**: Persist user data securely and efficiently.
- **Swift Concurrency**: Utilize Swift 6's concurrency features to ensure smooth performance and thread-safe operations.
- **MVVM Architecture**: Maintain a clean and scalable codebase with Model-View-ViewModel design.

---

## Tech Stack

- **Language**: Swift 6
- **Architecture**: MVVM (Model-View-ViewModel)
- **Local Storage**: CoreData for persisting user data
- **Networking**: On-demand data integration from the CoinGecko API
- **Concurrency**: Utilizes `async/await` for network calls and CoreData operations, ensuring thread safety

---

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Open the project in Xcode:
   ```bash
   cd BitTrek
   open BitTrek.xcodeproj
   ```

3. Build and run the app on a simulator or connected device.

---

## Architecture Overview

BitTrek follows the **MVVM architecture**, ensuring a clean separation of concerns and testability:

- **Model**: Represents the data layer, including CoreData entities and API response models.
- **View**: Handles the UI components and binds to the ViewModel.
- **ViewModel**: Serves as the intermediary between the Model and View, implementing business logic and exposing data to the UI.

---

## Core Features Implementation

### 1. **Cryptocurrency Data**
- Uses `URLSession` with `async/await` to fetch live cryptocurrency data from the CoinGecko API.
- Implements error handling for network requests, ensuring smooth user experience.

### 2. **CoreData Integration**
- Efficiently persists user data such as portfolio holdings.
- Thread-safe operations using Swift concurrency to prevent data corruption.

### 3. **Concurrency Safety**
- Fully compliant with Swift 6 concurrency standards.
- Ensures thread-safe access to CoreData and background tasks with `@MainActor` and structured concurrency.

---

## Screenshots



---

## Requirements

- iOS 18.0 or later

---

## Future Improvements

- Add push notifications for cryptocurrency price alerts.
- Implement advanced analytics and charts for portfolio trends.
- Multi-language support for international users.

---

## Credits

- **API**: [CoinGecko API](https://www.coingecko.com/en)
- **Developer**: [Kush Patel]
- **Guidence**: [Nick Sarno]
---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

Thank you for using BitTrek!
