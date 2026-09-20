# 📱 Chatify — Flutter-messenger

Chatify is a modern messaging, audio, and video calling app inspired by WhatsApp. Create groups, chat in real time, and sync your devices across platforms: Android, Windows, and Web.

<p align="center">
  <img src="/assets/vectors/logos/chatify_logo_blue.svg" width="250" alt="Chatify Logo">
</p>

---

## 🚀 Key Features

- 💬 Real-time messaging
- 📞 Audio and video calls (WebRTC)
- 👥 Group chat creation and management
- 📷 Image and file sharing
- 🖥 Support for Android, Web, and Windows
- 🔐 Firebase authentication (Google Sign-In)
- ☁️ Data storage in Firestore
- 🔔 Real-time notifications
- 🌓 Light and dark theme support
- 🎨 Customizable interface color

---

## 🧪 Demonstration (screenshots)

| Chat                              | Call                              | Group                               |
|-----------------------------------|-----------------------------------|-------------------------------------|
| ![](/assets/screenshots/chat.png) | ![](/assets/screenshots/call.png) | ![](/assets/screenshots/group.png) |

## 📱 Supported platforms

| Planform | Status | Notes |
|---|:---:|---|
| <img src="/assets/vectors/logos/android.svg" width="24"> | ✅ | Fully supported |
| <img src="/assets/vectors/logos/web.svg" width="24"> | ✅ | Fully supported |
| <img src="/assets/vectors/logos/microsoft.svg" width="24"> | ✅ | Fully supported |
| <img src="/assets/vectors/logos/ios.svg" width="24"> | 🚧 | Planned |
| <img src="/assets/vectors/logos/macos.svg" width="24"> | 🚧 | Planned |
| <img src="/assets/vectors/logos/linux.svg" width="24"> | ✅ | Fully supported |

---

## 🛠 Installation

### 1. Cloning the project

```dart
git clone https://github.com/dreamerenigma/chatify-flutter.git
cd chatify-flutter
```

### 2. Installing dependencies

```dart
flutter pub get
```

### 3. Adding configurations

Create a file in the `lib/config.dart` directory and add your API keys, tokens, and other settings:

```dart
const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID';
const String googleClientSecret = 'YOUR_GOOGLE_CLIENT_SECRET';
```

### 4. Launching the application

For Android: ```dart flutter run -d android```

For Web: ```dart flutter run -d chrome```

For Windows: ```dart flutter run -d windows```

### 5. Release build

For Android APK: ```dart flutter build apk --release```

For Web: ```dart flutter build web```

### Licenses

See [Third-Party Notices](docs/THIRD_PARTY_NOTICES.md).
