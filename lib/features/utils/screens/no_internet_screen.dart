import 'package:flutter/material.dart';
import 'dart:async';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helper/helper_functions.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key, required this.image, required this.onRetry});

  final String image;
  final VoidCallback onRetry;

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> {
  bool _isLoading = false;

  void _handleRetry() {
    setState(() {
      _isLoading = true;
    });

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _isLoading = false;
      });

      widget.onRetry();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final textColor = isDarkMode ? ChatifyColors.white : ChatifyColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? ChatifyColors.youngNight : ChatifyColors.light,
      body: Center(
        child: _isLoading
          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textColor))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.image, width: HelperFunctions.screenWidth() * 0.8, height: HelperFunctions.screenHeight() * 0.4, fit: BoxFit.contain),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(S.of(context).noInternetConnection, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: textColor)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(S.of(context).checkInternetSettings, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: textColor.withAlpha((0.7 * 255).toInt()))),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleRetry,
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(S.of(context).loadMore),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
