import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/light_dialog.dart';

class ConfigureProxyScreen extends StatefulWidget {
  const ConfigureProxyScreen({super.key});

  @override
  State<ConfigureProxyScreen> createState() => _ConfigureProxyScreenState();
}

class _ConfigureProxyScreenState extends State<ConfigureProxyScreen> {
  final TextEditingController _proxyController = TextEditingController();
  final FocusNode _proxyFocusNode = FocusNode();

  @override
  void dispose() {
    _proxyController.dispose();
    _proxyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text('Настроить прокси-сервер', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'addProxy',
          onPressed: () async {},
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: Icon(Icons.check_rounded, size: 28, color: ChatifyColors.black),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                  child: TextField(
                    controller: _proxyController,
                    focusNode: _proxyFocusNode,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: 'Прокси-сервер',
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.steelGrey, width: 1)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: accentColor, width: 1.5)),
                    ),
                  ),
                ),
              ),
              CustomDivider(indent: 20, endIndent: 20, left: 0, right: 0, top: 0, bottom: 0,),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
                child: Text('Порты (необязательно)', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
              ),
              _buildPortItem(
                context,
                title: 'Порт чата',
                value: 'По умолчанию',
                onTap: () {},
              ),
              SizedBox(height: 8),
              _buildPortItem(
                context,
                title: 'Порт медиа',
                value: 'По умолчанию',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortItem(BuildContext context, {required String title, required String value, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                const SizedBox(height: 3),
                Text(value, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
