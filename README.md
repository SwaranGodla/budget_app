# Budget App

A comprehensive budget tracking application built with **Flutter** and **Riverpod** for state management, designed to help users manage their finances effectively across mobile and web platforms.

## 🚀 Features

-   **Cross-Platform Support**: Works seamlessly on Android, iOS, and Web.
-   **Authentication**: Secure user login and registration using Firebase Authentication (Email/Password & Google Sign-In).
-   **Real-time Database**: Stores user data securely in Cloud Firestore with real-time synchronization.
-   **Budget Dashboard**:
    -   Visual overview of Budget Left, Total Expense, and Total Income.
    -   Interactive lists for Expenses and Incomes.
-   **Expense & Income Tracking**: Easily add expenses and income sources with a simple UI.
-   **Responsive Design**: optimized layouts for both mobile and web use cases.

## 🛠️ Tech Stack

-   **Frontend**: [Flutter](https://flutter.dev/) (Dart)
-   **State Management**: [Riverpod](https://riverpod.dev/) (`hooks_riverpod`)
-   **Backend**: [Firebase](https://firebase.google.com/)
    -   Firebase Authentication
    -   Cloud Firestore
-   **Utilities**:
    -   `google_fonts`: Custom typography.
    -   `url_launcher`: Opening external links.
    -   `logger`: Better logging.

## 📂 Project Structure

```
lib/
├── components.dart          # Reusable UI components (Buttons, Dialogs, Text styles)
├── firebase_options.dart    # Firebase configuration (Auto-generated)
├── main.dart                # Application entry point
├── responsive_handler.dart  # Handles switching between Mobile and Web views
├── view_model.dart          # core business logic and state management
├── mobile/
│   ├── expense_view_mobile.dart  # Dashboard view for Mobile
│   ├── login_view_mobile.dart    # Login screen for Mobile
│   └── register_view_mobile.dart # Registration screen for Mobile
└── web/
    ├── expense_view_web.dart     # Dashboard view for Web
    ├── login_view_web.dart       # Login screen for Web
    └── register_view_web.dart    # Registration screen for Web
```

## 🏁 Getting Started

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
-   A [Firebase](https://console.firebase.google.com/) project set up.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd budget_app
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup**:
    -   Ensure you have the `firebase_options.dart` file configured for your project. If not, use the FlutterFire CLI to configure it:
        ```bash
        flutterfire configure
        ```
    -   Enable **Authentication** (Email/Password and Google Sign-In) in your Firebase Console.
    -   Create a **Cloud Firestore** database.

4.  **Run the App**:
    -   **Mobile**: Connect a device or start an emulator.
        ```bash
        flutter run
        ```
    -   **Web**:
        ```bash
        flutter run -d chrome
        ```

## 📝 Setup Instructions for Students

This project is part of the "Connect Firebase to Flutter project using CLI" lecture.

1.  **Connect Firebase**: Follow the lecture instructions to generate your own `firebase_options.dart`.
2.  **Run**: The app will initially show a blank screen. Code along with the video to build the features, and eventually, the full app will be functional.