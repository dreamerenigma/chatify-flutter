import 'dart:developer';
import 'package:flutter/material.dart';

class CallApp extends StatelessWidget {
  final String userId;

  const CallApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    log('✅ CallApp.build выполнен');

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('📞 Вызов пользователя $userId'),
        ),
      ),
    );
  }
}
