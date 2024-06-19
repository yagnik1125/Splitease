# SplitEase: Expense Tracker App

Welcome to SplitEase, your go-to app for tracking and managing expenses with friends and groups. This app allows you to seamlessly add friends, create groups, and track shared expenses, making it easier to split bills and keep track of who owes whom.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication:** Secure login and registration using Firebase Authentication.
- **Add Friends:** Easily add and manage friends within the app.
- **Group Management:** Create and manage groups for shared expenses.
- **Expense Tracking:** Add, edit, and delete expenses with detailed breakdowns.
- **Net Balance Calculation:** Automatically calculates the net balance between friends.
- **Real-time Updates:** Real-time data synchronization using Firebase Firestore.
- **Responsive Design:** Optimized for both Android and iOS devices.

## Screenshots

![Login Screen](screenshots/login.png)
*Login Screen*

![Friends List](screenshots/friends_list.png)
*Friends List*

![Add Expense](screenshots/add_expense.png)
*Add Expense*

## Installation

To get a local copy up and running, follow these steps:

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/splitease.git
   cd splitease
    ```
2. **Install dependencies:**
   ```sh
   flutter pub get
    ```
3. **Set up Firebase:**
   ```sh
    Go to Firebase Console and create a new project.
    Add Android and iOS apps to your Firebase project.
    Download the google-services.json file for Android and GoogleService-Info.plist file for iOS and place them in the respective directories.
    ```
4. **Run the app:**
   ```sh
   flutter run
    ```
**Usage**
    Login/Register: Create an account or log in using your email and password.
    Add Friends: Navigate to the Friends tab and add new friends by providing their email.
    Create Groups: Go to the Groups tab and create a new group by adding friends.
    Track Expenses: Add expenses by selecting friends or groups, enter the details, and save.
    View Balances: Check the net balance with friends to see who owes whom.

**Technologies Used**

    Flutter: Front-end framework for building cross-platform mobile applications.
    Firebase Authentication: Secure authentication for users.
    Firebase Firestore: Real-time database for storing and syncing app data.
    Cached Network Image: Efficiently loading images from the network.

**Contributing**

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

    Fork the Project
    Create your Feature Branch (git checkout -b feature/AmazingFeature)
    Commit your Changes (git commit -m 'Add some AmazingFeature')
    Push to the Branch (git push origin feature/AmazingFeature)
    Open a Pull Request

**License**

Distributed under the MIT License. See LICENSE for more information.