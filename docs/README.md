# 📱 Chatify — Flutter-мессенджер

Chatify — это современное приложение для обмена сообщениями, аудио и видео-звонков, вдохновлённое WhatsApp. Создавайте группы, общайтесь в реальном времени и синхронизируйте свои устройства между платформами: Android, Windows и Web.

![Chatify Logo](/assets/logos/chatify-logo-light.png)

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

---

## 🛠 Установка

### 1. Клонирование проекта

```bash
git clone https://github.com/dreamerenigma/chatify-flutter.git
cd chatify-flutter
```

### 2. Установка зависимостей

```flutter pub get
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
