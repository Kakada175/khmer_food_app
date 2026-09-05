<div align="center">

  <img src="assets/images/splash_logo.png" alt="Khmer Food App Logo" width="140" height="140" style="border-radius: 50%;" />

  # 🍜 Khmer Food App
  ### *A Culinary Journey Through Cambodia*

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![GetX](https://img.shields.io/badge/State_Management-GetX-orange?style=for-the-badge)](https://pub.dev/packages/get)
  [![Laravel](https://img.shields.io/badge/Backend-Laravel-%23FF2D20.svg?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
  [![Platform](https://img.shields.io/badge/Platforms-iOS%20|%20Android-brightgreen?style=for-the-badge)](https://flutter.dev)

  <p align="center">
    <strong>Khmer Food App</strong> is a rich, authentic, and feature-packed mobile application designed to bring the traditional tastes of Cambodia right to your kitchen.
  </p>

</div>

---

## 📌 Table of Contents

- [📖 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [🎨 Visual Highlights & Assets](#-visual-highlights--assets)
- [📱 App Screens Breakdown](#-app-screens-breakdown)
  - [1. Splash Screen](#1--splash-screen)
  - [2. Auth Flow (Login & Sign Up)](#2--auth-flow-login--sign-up)
  - [3. Main Home Shell](#3--main-home-shell)
  - [4. Food Detail & Recipes](#4--food-detail--recipes)
  - [5. Province Specialties](#5--province-specialties)
  - [6. Festival Foods](#6--festival-foods)
  - [7. AI Assistant](#7--ai-assistant)
- [🛠️ Technology Stack & Dependencies](#%EF%B8%8F-technology-stack--dependencies)
- [📂 Project Architecture](#-project-architecture)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup (Laravel)](#backend-setup-laravel)
  - [Frontend Setup (Flutter)](#frontend-setup-flutter)
- [📄 License](#-license)

---

## 📖 Overview

**Khmer Food App** combines authentic Cambodian recipes, regional delicacies, and festival traditions into one comprehensive culinary guide. Whether you are searching for a specific dish, exploring what a certain province has to offer, or looking for AI-assisted cooking tips, this app provides a delightful user experience powered by GetX state management and a robust Laravel backend.

---

## ✨ Key Features

- 🍲 **Authentic Recipes**: Explore traditional Cambodian dishes with step-by-step cooking guides and ingredients.
- 🗺️ **Provincial Cuisine**: Discover local delicacies and specialties from different provinces across Cambodia.
- 🎉 **Festival Foods**: Special collections of food tied to Cambodian festivals and cultural events.
- 🤖 **AI Assistant**: Get intelligent, contextual help with ingredients, alternatives, and cooking tips.
- 🔐 **Authentication**: Secure Login & Sign-Up flow communicating with the Laravel backend.
- 👨‍🍳 **Admin Panel**: Dedicated admin interface for managing recipes, categories, and content directly from the app.
- ❤️ **Favorites**: Save your preferred recipes for quick and easy access later.

---

## 🎨 Visual Highlights & Assets

<div align="center">
  <table>
    <tr>
      <td align="center" width="33%">
        <img src="assets/images/discover_food.png" width="220" alt="Discover Food" /><br />
        <b>Discover Authentic Food</b>
      </td>
      <td align="center" width="33%">
        <img src="assets/images/step_by_step.png" width="220" alt="Cook Step by Step" /><br />
        <b>Cook Step by Step</b>
      </td>
      <td align="center" width="33%">
        <img src="assets/images/ai_assistant.png" width="220" alt="AI Cooking Help" /><br />
        <b>AI Cooking Help</b>
      </td>
    </tr>
  </table>
</div>

---

## 📱 App Screens Breakdown

The app consists of carefully crafted screens and shells designed to deliver a smooth user flow:

```
[ Splash Screen ] ➡️ [ Login / Sign Up ] ➡️ [ Home Shell ]
                                               ├── 🏠 Home Screen
                                               ├── 🗺️ Province Screen
                                               ├── 🎉 Festivals Screen
                                               ├── 🤖 AI Assistant Screen
                                               └── ⚙️ Admin Screen
```

### 1. 🚀 Splash Screen

<p align="center">
  <img src="assets/images/screenshots/splash_screen.png" alt="Splash Screen" width="320" />
</p>

- **Description**: The welcoming screen of the application featuring the brand logo and smooth entrance animations.
- **Key Features**: Smooth routing logic that determines whether to send the user to the Login screen or directly to the Home Shell based on session state.

---

### 2. 🔑 Auth Flow (Login & Sign Up)

<div align="center">
  <table>
    <tr>
      <td align="center" width="50%">
        <img src="assets/images/screenshots/login_screen.png" width="300" alt="Login" /><br />
        <b>Login Screen</b>
      </td>
      <td align="center" width="50%">
        <img src="assets/images/screenshots/signup_screen.png" width="300" alt="Sign Up" /><br />
        <b>Sign Up Screen</b>
      </td>
    </tr>
  </table>
</div>

- **Description**: Secure sign-in and registration portal.
- **Key Features**: Email & password validation, API integration with the Laravel backend for secure token generation, and smooth transitions between login and registration.

---

### 3. 🏠 Main Home Shell

<p align="center">
  <img src="assets/images/screenshots/home_shell.png" alt="Main Home Shell" width="320" />
</p>

- **Description**: The central navigation hub wrapping the core app tabs.
- **Key Features**: Clean bottom navigation bar switching seamlessly between Home, Provinces, Festivals, and Profile. Uses GetX for efficient routing and state preservation.

---

### 4. 🥘 Food Detail & Recipes

<p align="center">
  <img src="assets/images/screenshots/food_detail.png" alt="Food Detail Screen" width="320" />
</p>

- **Description**: The core content view for any specific dish.
- **Key Features**:
  - High-quality hero image using `cached_network_image`.
  - Detailed list of required ingredients.
  - Step-by-step cooking instructions pulled directly from the `RecipeStep` API models.
  - Rating bar utilizing `flutter_rating_bar`.

---

### 5. 🗺️ Province Specialties

<p align="center">
  <img src="assets/images/screenshots/province_screen.png" alt="Province Screen" width="320" />
</p>

- **Description**: A geographical approach to exploring food.
- **Key Features**: Interactive list of Cambodian provinces, filtering all available recipes by their region of origin.

---

### 6. 🎉 Festival Foods

<p align="center">
  <img src="assets/images/screenshots/festival_screen.png" alt="Festivals Screen" width="320" />
</p>

- **Description**: Seasonal and traditional dishes tied to specific Cambodian holidays (e.g., Khmer New Year, Pchum Ben).
- **Key Features**: Themed collections of food that highlight the cultural significance of the dish.

---

### 7. 🤖 AI Assistant

<p align="center">
  <img src="assets/images/screenshots/ai_assistant.png" alt="AI Assistant Screen" width="320" />
</p>

- **Description**: A smart companion to help you in the kitchen.
- **Key Features**: Chat interface to ask questions about recipe alternatives, nutritional facts, or general cooking advice.

---

## 🛠️ Technology Stack & Dependencies

| Layer | Technology / Package | Purpose |
| :--- | :--- | :--- |
| **Core Framework** | [Flutter](https://flutter.dev) (Dart SDK `^3.10.3`) | Cross-platform mobile UI development |
| **State Management** | [`get`](https://pub.dev/packages/get) | High-performance state management & routing |
| **Backend API** | [Laravel](https://laravel.com/) (PHP `>=8.1`) | RESTful API, authentication, and database ORM |
| **Database** | SQLite (Default) / MySQL | Data storage for users, recipes, and collections |
| **Networking** | [`http`](https://pub.dev/packages/http) | API communication from Flutter to Laravel |
| **Image Caching** | [`cached_network_image`](https://pub.dev/packages/cached_network_image) | Efficient loading of remote food images |
| **Typography** | [`google_fonts`](https://pub.dev/packages/google_fonts) | Custom typography integration |
| **Local Storage** | [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Saving user sessions and app preferences |

---

## 📂 Project Architecture

The repository is structured as a monorepo, cleanly separating the client application from the server API:

```
khmer_food_app/
├── lib/                       # 📱 Flutter Frontend
│   ├── app/
│   │   ├── controllers/       # GetX business logic
│   │   ├── data/              # Models (e.g., food_model.dart, cooking_step_model.dart)
│   │   ├── modules/           # Screens & Views (auth, home, food_detail, ai_assistant, etc.)
│   │   ├── routes/            # GetX routing definitions
│   │   ├── theme/             # App colors and styling
│   │   └── translations/      # Localization support
│   └── main.dart              # Entry point of the mobile app
└── backend/                   # ⚙️ Laravel Backend
    ├── app/
    │   ├── Http/Controllers/  # API endpoints logic
    │   └── Models/            # Eloquent ORM (RecipeStep.php, Collection.php)
    ├── database/              # Migrations and SQLite database
    ├── routes/                # api.php and web.php routing
    └── .env                   # Server environment configuration
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.10.3`)
- [PHP](https://www.php.net/) (`>=8.1`) and [Composer](https://getcomposer.org/)
- Android Studio / VS Code with appropriate extensions

### Backend Setup (Laravel)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install PHP dependencies:
   ```bash
   composer install
   ```
3. Set up the environment configuration:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```
4. Create the SQLite database and run migrations:
   ```bash
   touch database/database.sqlite
   php artisan migrate
   ```
5. Start the local server:
   ```bash
   php artisan serve
   ```
   *The API will be hosted at `http://127.0.0.1:8000`.*

### Frontend Setup (Flutter)

1. Open a new terminal and navigate to the project root:
   ```bash
   cd khmer_food_app
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Ensure the API base URL in your Flutter code points to your local Laravel server.
4. Run the application on an emulator or connected device:
   ```bash
   flutter run
   ```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
