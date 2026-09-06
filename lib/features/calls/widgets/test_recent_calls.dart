import '../../chat/models/user_model.dart';
import '../models/recent_call_model.dart';

final List<RecentCallModel> testRecentCalls = [
  RecentCallModel(
    user: UserModel(
      id: 'test_1',
      image: '',
      about: 'Люблю общаться',
      status: '',
      phoneNumber: '+491111111111',
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
      phoneNumber: '+492222222222',
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
      phoneNumber: '+493333333333',
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
      phoneNumber: '+494444444444',
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
