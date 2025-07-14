import 'package:flutter/material.dart';
import 'package:chatify/features/chat/models/user_model.dart';

class UserProvider extends InheritedWidget {
  final UserModel user;

  const UserProvider({super.key, required this.user, required super.child});

  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return oldWidget.user != user;
  }
}
