import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../input/search_text_input.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  final TextEditingController favoriteController = TextEditingController();
  bool hasResults = false;
  final List<String> favoriteMessages = [];

  @override
  Widget build(BuildContext context) {
    hasResults = favoriteMessages.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).favoriteMessages, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SearchTextInput(hintText: S.of(context).searchFavoriteMessages, controller: favoriteController, padding: EdgeInsets.all(16)),
          if (hasResults && favoriteMessages.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${S.of(context).message} ${index + 1}'),
                  subtitle: Text(S.of(context).messageText),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(S.of(context).noResults, style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
