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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
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
      resizeToAvoidBottomInset: false,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).helpCenter, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
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
                    padding: const EdgeInsets.all(16),
                    child: Text(S.of(context).openInBrowser, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.youngNight, width: 0.5),
                ),
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: S.of(context).searchHelpCenter,
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: const Icon(Icons.search, color: ChatifyColors.darkGrey),
                      suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close, color: ChatifyColors.darkGrey),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).requestFocus(_focusNode);
                          },
                        )
                        : null,
                    ),
                  ),
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(S.of(context).nothingFound, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).pleaseCheckSpellingDifferentKeywords,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey), textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
