import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class SearchHelpCenterScreen extends StatefulWidget {
  const SearchHelpCenterScreen({super.key});

  @override
  SearchHelpCenterScreenState createState() => SearchHelpCenterScreenState();
}

class SearchHelpCenterScreenState extends State<SearchHelpCenterScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).helpCenter),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              PopupMenuButton<int>(
                position: PopupMenuPosition.under,
                color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 1) {}
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Открыть в браузере', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(20.0)),
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: Colors.blue,
            ),
            child: TextField(
              focusNode: _focusNode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: ChatifyColors.darkGrey),
                hintText: 'Поиск в Справочном центре',
                hintStyle: TextStyle(color: ChatifyColors.darkGrey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
          )
        ),
      ),
    );
  }
}
