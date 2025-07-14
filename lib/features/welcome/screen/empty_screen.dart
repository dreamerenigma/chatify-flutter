import 'package:chatify/features/authentication/screens/add_account_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/constants/app_colors.dart';

class EmptyScreen extends StatefulWidget {
  const EmptyScreen({super.key});

  @override
  State<EmptyScreen> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<EmptyScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(context, createPageRoute(const AddAccountScreen(isFromSplashScreen: false, showBackButton: true)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                  highlightColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  period: const Duration(seconds: 1),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                              highlightColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                              period: const Duration(seconds: 1),
                              child: Container(
                                width: 20,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Shimmer.fromColors(
                            baseColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                            highlightColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                            period: const Duration(seconds: 1),
                            child: Container(
                              width: 35,
                              height: 10,
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Shimmer.fromColors(
                        baseColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                        highlightColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        period: const Duration(seconds: 1),
                        child: Container(
                          width: 220,
                          height: 18,
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
