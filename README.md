# Hayaa App 🎙️✨

**Hayaa** is a feature-rich, cross-platform mobile application built using **Flutter**. It is designed to deliver a vibrant social experience, combining real-time audio broadcasting, community engagement, and an interactive digital economy.

---

## 🚀 Key Features

### 🎙️ Audio Rooms & Live Streaming
*   **Real-Time Audio Rooms:** High-quality, low-latency live audio rooms for group discussions and hosting events.
*   **Interactive Engagement:** Features for mic management, requesting to speak, and live audience interaction.

### 💬 Instant Messaging & Social Networking
*   **Real-time Chat:** Seamless text-based communication with support for private direct messages (DMs) and room chats.
*   **User Posts & Stories:** A dedicated social feed where users can share daily updates, images, and interactive stories that disappear after 24 hours.

### 👑 Digital Marketplace & Personalization
*   **Badge Store (متجر الشارات):** A specialized virtual shop where users can purchase and display unique badges on their profiles.
*   **Entrance Effects (الدخلات):** Premium entry animations and custom effects that trigger when a user joins an audio room.

### 💳 Secure Payment Gateway
*   **In-App Purchases:** Integrated secure payment processing for buying virtual coins, badges, and premium features smoothly.

---

## 🛠️ Tech Stack & Architecture

*   **Frontend:** Flutter & Dart (Cross-platform Android & iOS)
*   **Real-Time Audio:** Powered by robust WebRTC / Cloud Audio streaming solutions (e.g., ZegoCloud).
*   **Backend Support:** Real-time data sync, push notifications, and secure API integrations.
*   **State Management:** Clean and scalable state management architecture.

---

## 🏁 Getting Started

### Prerequisites
Before you begin, ensure you have the following installed:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest stable version)
*   Android Studio / Xcode
*   Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/hayaa-app.git](https://github.com/your-username/hayaa-app.git)
   cd hayaa-app


## GitHub Actions build configuration

The Android APK workflow uses these repository Actions secrets when the related feature is enabled:

- `SUPABASE_PUBLISHABLE_KEY`: the public publishable key from Supabase **Settings → API Keys**. Never use a Supabase `service_role` or secret key in the app.
- `ANDROID_DEBUG_KEYSTORE_BASE64`: optional Base64 content of the stable Android debug keystore used for the current test build. Supplying the same keystore on every build keeps the signing SHA-1 stable for Google Sign-In. Without it, GitHub Actions generates a temporary key and Google Sign-In may fail because its SHA-1 changes.
- `GOOGLE_SERVICES_JSON`: optional complete Firebase Android configuration JSON. If omitted, the checked-in `android/app/google-services.json` is used. The workflow verifies project `voice-up-84ee1` and package `com.egycode.hayaa`.

Add secrets under **Settings → Secrets and variables → Actions** in the GitHub repository. The current release build is still signed with the Android debug signing configuration and is intended for testing, not Play Store publishing.
