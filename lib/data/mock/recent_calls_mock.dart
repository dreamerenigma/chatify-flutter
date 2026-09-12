import '../../features/calls/models/recent_call_model.dart';
import '../../features/chat/models/user_model.dart';

final List<RecentCallModel> mockRecentCalls = [
  RecentCallModel(
    user: UserModel(
      id: 'test_1',
      image: '',
      about: 'Люблю общаться',
      status: '',
      phoneNumber: '+7 927 148-11-15',
      name: 'Александр',
      surname: 'Иванов',
      username: 'alexander',
      createdAt: DateTime.now(),
      isOnline: true,
      lastActive: DateTime.now(),
      pushToken: '',
      email: 'alex@example.com',
      isTyping: false,
      role: 'User',
    ),
    time: DateTime.now().subtract(
      const Duration(minutes: 20),
    ),
    isIncoming: true,
  ),

  RecentCallModel(
    user: UserModel(
      id: 'test_2',
      image: '',
      about: '',
      status: '',
      phoneNumber: '+7 965 247-34-26',
      name: 'Мария',
      surname: 'Петрова',
      username: 'maria',
      createdAt: DateTime.now(),
      isOnline: false,
      lastActive: DateTime.now(),
      pushToken: '',
      email: 'maria@example.com',
      isTyping: false,
      role: 'User',
    ),
    time: DateTime.now().subtract(
      const Duration(hours: 2),
    ),
    isIncoming: false,
  ),

  RecentCallModel(
    user: UserModel(
      id: 'test_3',
      image: '',
      about: '',
      status: '',
      phoneNumber: '+7 917 341-23-63',
      name: 'Дмитрий',
      surname: 'Смирнов',
      username: 'dmitry',
      createdAt: DateTime.now(),
      isOnline: false,
      lastActive: DateTime.now(),
      pushToken: '',
      email: 'dmitry@example.com',
      isTyping: false,
      role: 'User',
    ),
    time: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    isIncoming: true,
    isMissed: true,
  ),

  RecentCallModel(
    user: UserModel(
      id: 'test_4',
      image: '',
      about: '',
      status: '',
      phoneNumber: '+7 999 239-21-82',
      name: 'Анна',
      surname: 'Кузнецова',
      username: 'anna',
      createdAt: DateTime.now(),
      isOnline: true,
      lastActive: DateTime.now(),
      pushToken: '',
      email: 'anna@example.com',
      isTyping: false,
      role: 'User',
    ),
    time: DateTime.now().subtract(
      const Duration(days: 2),
    ),
    isIncoming: true,
    isVideo: true,
  ),
];
