import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/payment_sheet_step_type.dart';
import '../../../../data/bank_data.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/bank_model.dart';
import '../../models/user_model.dart';

void showPaymentBottomSheetDialog(BuildContext context, UserModel user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: false,
    backgroundColor: ChatifyColors.transparent,
    barrierColor: ChatifyColors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.96),
    builder: (context) {
      return PaymentBottomSheet(user: user);
    },
  );
}

class PaymentBottomSheet extends StatefulWidget {
  final UserModel user;

  const PaymentBottomSheet({
    super.key,
    required this.user
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController searchCountryController = TextEditingController();
  final TextEditingController amountController = TextEditingController(text: '0');
  final FocusNode inputFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();
  bool isLoadingProfileImage = false;
  bool _isRefreshing = false;
  String? profileImageUrl;
  BankModel? _selectedBank;
  BankModel? _preferredBank;
  PaymentSheetStepType _currentStep = PaymentSheetStepType.contactsOnly;

  @override
  void initState() {
    super.initState();
    amountController.addListener(_onAmountChanged);
    _loadProfileImage();
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    amountFocusNode.dispose();
    _bankController.dispose();
    searchCountryController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  void _handleBack() {
    switch (_currentStep) {
      case PaymentSheetStepType.contactsOnly:
        Navigator.pop(context);
        break;
      case PaymentSheetStepType.bankSelection:
        Navigator.pop(context);
        break;
      case PaymentSheetStepType.paymentConfirmation:
        setState(() {
          _selectedBank = null;
          _currentStep = PaymentSheetStepType.bankSelection;
        });
        break;
    }
  }

  void _onAmountChanged() {
    final text = amountController.text;

    if (text.length > 1 && text.startsWith('0')) {
      final normalized = text.replaceFirst(RegExp(r'^0+'), '');
      final value = normalized.isEmpty ? '0' : normalized;

      amountController.value = amountController.value.copyWith(text: value, selection: TextSelection.collapsed(offset: value.length), composing: TextRange.empty);
    }
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isContactsOnly = _currentStep == PaymentSheetStepType.contactsOnly;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: Icon(_currentStep == PaymentSheetStepType.paymentConfirmation ? Icons.arrow_back_rounded : Icons.close_rounded, size: 25),
                        splashRadius: 20,
                        tooltip: _currentStep == PaymentSheetStepType.paymentConfirmation ? 'Назад' : 'Закрыть',
                        onPressed: _handleBack,
                      ),
                    ),
                  ),
                  Positioned.fill(child: Center(child: Text('Денежные переводы', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)))),
                  Positioned(
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: PopupMenuButton<int>(
                      tooltip: S.of(context).more,
                      position: PopupMenuPosition.under,
                      offset: const Offset(-8, 0),
                      menuPadding: const EdgeInsets.symmetric(vertical: 4),
                      constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
                      icon: const Icon(Icons.more_vert_rounded, size: 25),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          enabled: false,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AppPopupMenuItem(
                            text: 'Обновить',
                            onTap: () {
                              Navigator.pop(context);
                              _refreshContent();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isRefreshing)
              Expanded(child: Center(child: CircularProgressIndicator(color: colorsController.getColor(colorsController.selectedColorScheme.value))))
            else ...[
              if (!isContactsOnly) ...[
                _buildUserCard(),
                SizedBox(height: 10),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: switch (_currentStep) {
                    PaymentSheetStepType.contactsOnly => _buildContactsOnly(),
                    PaymentSheetStepType.bankSelection => _buildBankSelection(),
                    PaymentSheetStepType.paymentConfirmation => _buildPaymentConfirmation(),
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactsOnly() {
    return Container(
      key: const ValueKey('contacts-only'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.softNight),
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: SvgPicture.asset(ChatifyVectors.contactNote, width: 28, height: 28, colorFilter: ColorFilter.mode(ChatifyColors.steelGrey, BlendMode.srcIn)),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Переводить деньги можно только контактам',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400, height: 1.4),
            ),
          ),
          const SizedBox(height: 35),
          _buildContactInfoItem(svgIcon: ChatifyVectors.phoneNumpadOutline, text: 'Добавьте человека в контакты'),
          const SizedBox(height: 18),
          _buildContactInfoItem(icon: Icons.person_add_alt_outlined, text: 'Используйте номер телефона из контактов'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = PaymentSheetStepType.bankSelection;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                side: BorderSide.none,
              ),
              child: Text('Понятно', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem({IconData? icon, String? svgIcon, required String text}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: svgIcon != null
                ? SvgPicture.asset(svgIcon, width: 21, height: 21, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, BlendMode.srcIn))
                : Icon(icon, size: 25, color: ChatifyColors.darkGrey),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: profileImageUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    foregroundColor: ChatifyColors.white,
                    child: SvgPicture.asset(ChatifyVectors.profile, width: 50, height: 50),
                  ),
                ),
              ),
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.softGrey),
                  child: Container(margin: const EdgeInsets.all(3), child: SvgPicture.asset(ChatifyVectors.sbp, width: 12, height: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Получить по СБП:', style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                    SizedBox(width: 2),
                    Text(
                      widget.user.phoneNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankSelection() {
    return Column(
      key: const ValueKey('bank-selection'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Из какого банка перевести?',
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextField(
                  controller: searchCountryController,
                  focusNode: inputFocusNode,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: 'Поиск',
                    fillColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.lightGrey,
                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon: const Icon(Icons.search_rounded, size: 25, color: ChatifyColors.darkGrey),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: banks.map((bank) {
                  return _buildBankItem(bank);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankItem(BankModel bank) {
    final isSelected = _preferredBank == bank;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          setState(() {
            _selectedBank = bank;
            _preferredBank = bank;
            _currentStep = PaymentSheetStepType.paymentConfirmation;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            amountFocusNode.requestFocus();
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: ClipRRect(borderRadius: BorderRadius.circular(14), child: SvgPicture.asset(bank.icon, width: 42, height: 42, fit: BoxFit.contain)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(bank.name, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400))),
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isSelected
                  ? Icon(Icons.check_circle_rounded, key: const ValueKey('selected'), size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value))
                  : const SizedBox(key: ValueKey('empty'), width: 24,height: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentConfirmation() {
    final bank = _selectedBank!;

    return Container(
      key: const ValueKey('payment-confirmation'),
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectedBankCard(bank),
          const SizedBox(height: 8),
          Text('Перепроверьте данные в приложении банка', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400)),
          const Spacer(),
          Text('Сумма', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const SizedBox(height: 4),
          TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextField(
                  controller: amountController,
                  focusNode: amountFocusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 32, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                IgnorePointer(
                  child: AnimatedBuilder(
                    animation: amountController,
                    builder: (context, _) {
                      final text = amountController.text;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(text.isEmpty ? '0' : text, style: TextStyle(color: ChatifyColors.transparent, fontSize: 32, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 6),
                          Text('₽', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 32, fontWeight: FontWeight.w400)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          ),
          const SizedBox(height: 2),
          Text('Сумма от 10 ₽ до 300 000 ₽', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)
              ),
              child: Text('Перейти в банк', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedBankCard(BankModel bank) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          setState(() {
            _selectedBank = null;
            _currentStep = PaymentSheetStepType.bankSelection;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(borderRadius: BorderRadius.circular(14), child: SvgPicture.asset(bank.icon, width: 50, height: 50, fit: BoxFit.contain)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Мой банк', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 2),
                    Text(bank.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
