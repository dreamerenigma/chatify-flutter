import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'confirm_email_screen.dart';

class AddEmailScreen extends StatefulWidget {
  const AddEmailScreen({super.key});

  @override
  State<AddEmailScreen> createState() => _AddEmailScreenState();
}

class _AddEmailScreenState extends State<AddEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  bool isButtonEnabled = false;
  bool _isSending = false;

  final List<String> _emailDomains = ['@gmail.com', '@hotmail.com', '@outlook.com', '@yahoo.com', '@icloud.com', '@mail.ru', '@yandex.ru', '@proton.me'];

  bool get _showEmailSuggestions {
    return emailController.text.isNotEmpty && !emailController.text.contains('@');
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateInput);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        emailFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      isButtonEnabled = emailController.text.length >= 4;
    });
  }

  void _selectEmailDomain(String domain) {
    final text = emailController.text.trim();

    if (text.isEmpty) return;

    final atIndex = text.indexOf('@');
    final username = atIndex == -1 ? text : text.substring(0, atIndex);

    emailController.value = TextEditingValue(text: '$username$domain', selection: TextSelection.collapsed(offset: '$username$domain'.length));
    emailFocusNode.requestFocus();
  }

  Future<void> _submitEmail() async {
    if (!isButtonEnabled || _isSending) return;

    final email = emailController.text.trim();

    setState(() {
      _isSending = true;
    });

    try {
      await Dialogs.showProgressBarDialog(context, title: 'Отправка кода...');

      if (!mounted) return;

      Navigator.pop(context);

      if (!mounted) return;

      Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmEmailScreen(email: email)));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).addEmailAddress, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: 'Электронный адрес позволяет нам связаться с вами в случае проблем со входом, обращений в службу поддержки или обновлений аккаунта. Другие пользователи его не увидят. ',
                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                            ),
                            TextSpan(
                              text: 'Подробнее',
                              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSelectionTheme(
                            data: TextSelectionThemeData(
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            child: SizedBox(
                              child: TextFormField(
                                controller: emailController,
                                focusNode: emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Электронный адрес',
                                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1.5)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1.5)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1.5)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                          if (_showEmailSuggestions) ...[
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 38,
                              child: ScrollConfiguration(
                                behavior: NoGlowScrollBehavior(),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: _emailDomains.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final domain = _emailDomains[index];

                                    return Material(
                                      color: ChatifyColors.transparent,
                                      child: InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        onTap: () {
                                          _selectEmailDomain(domain);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey, width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            domain,
                                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: ElevatedButton(
                  onPressed: isButtonEnabled && !_isSending ? _submitEmail : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatifyColors.white,
                    backgroundColor: isButtonEnabled ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.mildNight,
                    disabledBackgroundColor: ChatifyColors.deepNight,
                    disabledForegroundColor: ChatifyColors.darkGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).next, style: TextStyle(color: isButtonEnabled ? ChatifyColors.black : ChatifyColors.softNight, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
