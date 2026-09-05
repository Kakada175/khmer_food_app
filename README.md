# Khmer Food App

Khmer Food App is a mobile application dedicated to exploring and discovering Cambodian (Khmer) cuisine. The app provides authentic recipes, step-by-step cooking guides, regional specialties by province, festival-related foods, and features an integrated AI assistant to help you in the kitchen.

## 🚀 Tech Stack

- **Frontend:** Flutter
- **State Management & Routing:** GetX
- **Backend:** Laravel (PHP)
- **Database:** SQLite (Default for development)

## ✨ Key Features

- **Home Feed:** Discover popular and featured Khmer dishes.
- **Search & Filter:** Easily find specific recipes or ingredients.
- **Regional Specialties:** Explore local foods categorized by Cambodian provinces.
- **Festival Foods:** Discover traditional meals for specific Cambodian festivals.
- **Detailed Recipes:** Step-by-step cooking guides and ingredients.
- **Favorites:** Save your preferred recipes for quick access.
- **AI Assistant:** Get intelligent cooking suggestions and help.
- **Admin Module:** Manage food items, categories, and content.
- **Authentication:** Secure user login and registration flows.

## 📁 Project Structure

This repository is a monorepo containing both the Flutter mobile application and the Laravel backend API.

- `/lib/` - Flutter application source code.
  - `app/modules/` - GetX modules for each screen (e.g., `auth`, `home`, `search`, `food_detail`, `ai_assistant`).
  - `app/controllers/` - GetX controllers for state management.
  - `app/data/` - Data layer including Models (e.g., `cooking_step_model.dart`) and API providers.
- `/backend/` - Laravel backend API.
  - `app/Models/` - Eloquent models (e.g., `RecipeStep.php`, `Collection.php`).
  - `routes/` - API and web routes.
  - `database/` - Database migrations and seeders.

## 🛠️ Getting Started

### Prerequisites

- **Flutter SDK:** `^3.10.3`
- **PHP:** `>= 8.1`
- **Composer:** For managing PHP dependencies.

### 1. Backend Setup (Laravel)

Navigate to the backend directory and set up the API:

```bash
cd backend

# Install dependencies
composer install

# Set up environment variables
cp .env.example .env

# Generate application key
php artisan key:generate

# Create a sqlite database file if it doesn't exist
touch database/database.sqlite

# Run database migrations
php artisan migrate

# Start the development server
php artisan serve
```
*The backend API will typically be available at `http://127.0.0.1:8000`.*

### 2. Frontend Setup (Flutter)

Open a new terminal window, navigate to the project root, and set up the Flutter app:

```bash
# From the project root (khmer_food_app)

# Install Flutter packages
flutter pub get

# Run the app
flutter run
```

> **Note:** Ensure that the API base URL in your Flutter app points to your local Laravel server (`http://127.0.0.1:8000` or your local IP address if testing on a physical device) during development.
