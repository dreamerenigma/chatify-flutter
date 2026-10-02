import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;

  const ConfirmEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isConfirming = false;

  bool get _isCodeComplete {
    return _codeController.text.length == 6;
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _codeFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    setState(() {});
  }

  Future<void> _confirmCode() async {
    if (!_isCodeComplete || _isConfirming) return;

    final code = _codeController.text;

    setState(() {
      _isConfirming = true;
    });

    try {
      log('EMAIL: ${widget.email}');
      log('CODE: $code');

    } finally {
      if (mounted) {
        setState(() {
          _isConfirming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = colorsController.getColor(colorsController.selectedColorScheme.value);
    final isCodeComplete = _isCodeComplete;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Подтвердите ваш электронный адрес', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Text(
                'Введите 6-значный код, отправленный на адрес\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('Неправильный электронный адрес?', style: TextStyle(color: themeColor, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _codeFocusNode.requestFocus();
                },
                child: Container(
                  width: 190,
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: _codeFocusNode.hasFocus ? themeColor : ChatifyColors.darkGrey, width: 1.5)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final code = _codeController.text;
                          final character = index < code.length ? code[index] : '';

                          return Row(
                            children: [
                              SizedBox(
                                width: 17,
                                child: Center(
                                  child: Text(
                                    character.isEmpty ? '—' : character,
                                    style: TextStyle(color: character.isEmpty ? ChatifyColors.darkGrey : ChatifyColors.white, fontSize: 18, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              if (index == 2)
                                const SizedBox(width: 12),
                            ],
                          );
                        }),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _codeController,
                            focusNode: _codeFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            autofocus: true,
                            decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Отправить новый код',
                  style: TextStyle(color: themeColor, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: ElevatedButton(
                  onPressed: isCodeComplete && !_isConfirming ? _confirmCode : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatifyColors.white,
                    backgroundColor: themeColor,
                    disabledBackgroundColor: ChatifyColors.deepNight,
                    disabledForegroundColor: ChatifyColors.darkGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Подтвердить', style: TextStyle(color: isCodeComplete ? ChatifyColors.black : ChatifyColors.softNight, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
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
