import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../utils/constants/app_animations.dart';
import 'no_internet_screen.dart';

class InternetAwareScreen extends StatefulWidget {
  final Widget connectedScreen;
  final String title;

  const InternetAwareScreen({super.key, required this.connectedScreen, required this.title});

  @override
  InternetAwareScreenState createState() => InternetAwareScreenState();
}

class InternetAwareScreenState extends State<InternetAwareScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!mounted) return;
      _updateConnectionStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);
    });
    _checkInitialConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResults = await _connectivity.checkConnectivity();
    if (!mounted) return;
    _updateConnectionStatus(connectivityResults.isNotEmpty ? connectivityResults.first : ConnectivityResult.none);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (!mounted) return;
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  void _retryConnection() {
    _checkInitialConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.connectedScreen : NoInternetScreen(image: AppAnimations.noInternetConnection, onRetry: _retryConnection);
  }
}
