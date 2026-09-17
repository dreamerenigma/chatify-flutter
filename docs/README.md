# 📱 Chatify — Flutter-мессенджер

Chatify — это современное приложение для обмена сообщениями, аудио и видео-звонков, вдохновлённое WhatsApp. Создавайте группы, общайтесь в реальном времени и синхронизируйте свои устройства между платформами: Android, Windows и Web.

<br>
<br>

<p style="text-align: center;">
  <img src="/assets/logos/chatify-logo-light.png" alt="Chatify Logo">
</p>

<br>
<br>

---

## 🚀 Основные возможности

- 💬 Обмен сообщениями в реальном времени
- 📞 Аудио- и видео- звонки (WebRTC)
- 👥 Создание и управление групповыми чатами
- 📷 Отправка изображений и файлов
- 🖥 Поддержка Android, Web и Windows
- 🔐 Firebase аутентификация (Google Sign-In)
- ☁️ Хранение данных в Firestore
- 🔔 Уведомления в реальном времени
- 🌓 Поддержка светлой и тёмной темы
- 🎨 Возможность выбора цвета интерфейса

---

## 🧪 Демонстрация (скриншоты)

| Чат                               | Звонок                            | Группы                              |
|-----------------------------------|-----------------------------------|-------------------------------------|
| ![](/assets/screenshots/chat.png) | ![](/assets/screenshots/call.png) | ![](/assets/screenshots/groups.png) |

## 📱 Поддерживаемые платформы

| Платформа                                | Статус | Заметки         |
|------------------------------------------|--------|-----------------|
| ![](/assets/vectors/logos/android.svg)   | ✅      | Fully supported |
| ![](/assets/vectors/logos/web.svg)       | ✅      | Fully supported |
| ![](/assets/vectors/logos/microsoft.svg) | ✅      | Fully supported |
| ![](/assets/vectors/logos/ios.svg)       | 🚧     | Planned         |
| ![](/assets/vectors/logos/macos.svg)     | 🚧     | Planned         |
| ![](/assets/vectors/logos/linux.svg)     | ✅      | Fully supported |

---

## 🛠 Установка

### 1. Клонирование проекта

```bash
git clone https://github.com/dreamerenigma/chatify-flutter.git
cd chatify-flutter
```

### 2. Установка зависимостей

```bash
flutter pub get
```

### 3. Добавление конфигураций
Создайте файл в каталоге lib/config.dart и добавьте туда свои ключи API, токены и другие настройки:

const String googleClientId = 'ВАШ_GOOGLE_CLIENT_ID';
const String googleClientSecret = 'ВАШ_GOOGLE_CLIENT_SECRET';

### 4. Запуск приложения

Для Android: flutter run -d android

Для Web: flutter run -d chrome

Для Windows: flutter run -d windows

### 5. Сборка релиза

Для Android APK: flutter build apk --release

Для Web: flutter build web

### Licenses

See [Third-Party Notices](docs/THIRD_PARTY_NOTICES.md).
