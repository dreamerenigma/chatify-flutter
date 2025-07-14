import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';
import 'package:flutter/material.dart';

class WindowCall extends StatelessWidget {
  final UserModel user;

  const WindowCall({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    log('🔵 Окно WindowCall построено для пользователя: ${user.name}');
    return Scaffold(
      body: WindowBorder(
        color: ChatifyColors.transparent,
        width: 0,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  const WindowButtons(),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Звонок с ${user.name}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton(),
      ],
    );
  }
}

