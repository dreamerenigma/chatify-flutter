import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddEmailScreen extends StatefulWidget {
  const AddEmailScreen({super.key});

  @override
  State<AddEmailScreen> createState() => _AddEmailScreenState();
}

class _AddEmailScreenState extends State<AddEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      isButtonEnabled = emailController.text.length >= 4;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Добавьте адрес эл. почты', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Мы отправим код подтверждения на этот электронный адрес.',
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeSm,
                        fontWeight: FontWeight.w400,
                        color: ChatifyColors.darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
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
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            fontSize: ChatifySizes.fontSizeMd,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Адрес эл. почты',
                            hintStyle: TextStyle(
                              color: ChatifyColors.darkGrey,
                              fontSize: ChatifySizes.fontSizeLg,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ChatifyColors.white),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ChatifyColors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ElevatedButton(
                onPressed: isButtonEnabled ? () {} : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: ChatifyColors.white,
                  backgroundColor: isButtonEnabled ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Далее', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
