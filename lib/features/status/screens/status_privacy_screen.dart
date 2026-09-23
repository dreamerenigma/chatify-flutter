import 'package:chatify/features/status/screens/share_screen.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/tiles/custom_radio_action_tile.dart';
import 'exceptions_screen.dart';

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({super.key});

  @override
  StatusPrivacyScreenScreenState createState() => StatusPrivacyScreenScreenState();
}

class StatusPrivacyScreenScreenState extends State<StatusPrivacyScreen> {
  final GetStorage storage = GetStorage();
  bool _isEnabled = false;
  bool _isHistoryVKEnabled = false;
  bool _isHistoryOKEnabled = false;
  bool _hasChanges = false;
  bool isPressed = false;
  int? _selectedValue;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedValue();
  }

  void _loadSelectedValue() {
    _selectedValue = storage.read<int>('selectedRadioValue') ?? 1;
  }

  void _saveSelectedValue(int value) {
    storage.write('selectedRadioValue', value);
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            title: Text(S.of(context).confidentialityStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                if (_hasChanges) {
                  CustomIconSnackBar.showAnimatedSnackBar(context, S.of(context).settingsSaved, icon: const Icon(Icons.check_circle_rounded), iconColor: ChatifyColors.success, position: SnackBarPositionType.bottom, offset: 90);
                }

                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(S.of(context).seeStatusUpdates, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
          RadioGroup<int>(
            groupValue: _selectedValue,
            onChanged: (value) {
              if (value == null || value == _selectedValue) return;

              setState(() {
                _selectedValue = value;
                _saveSelectedValue(value);
                _hasChanges = true;
              });

              _markAsChanged();
            },
            child: Column(
              children: [
                CustomRadioActionTile<int>(
                  icon: Icon(Icons.person_outline_rounded, size: 22, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                  title: S.of(context).myContacts,
                  value: 1,
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  inactiveIconColor: ChatifyColors.darkerGrey,
                  radioScale: 1.13,
                ),
                CustomRadioActionTile<int>(
                  icon: SvgPicture.asset(ChatifyVectors.personClose, width: 22, height: 22, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: S.of(context).contactsOtherThan,
                  subtitle: '${S.of(context).exception} ($counter)',
                  subtitleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  trailingText: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Изменить', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                      const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.chevron_right_rounded, size: 18, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      ),
                    ],
                  ),
                  value: 2,
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  inactiveIconColor: ChatifyColors.darkerGrey,
                  radioScale: 1.13,
                  onTrailingTap: () async {
                    final changed = await Navigator.push<bool>(context, createPageRoute(const ExceptionsScreen()));

                    if (changed == true) {
                      setState(() {
                        _hasChanges = true;
                      });
                    }
                  },
                ),
                CustomRadioActionTile<int>(
                  icon: SvgPicture.asset(ChatifyVectors.personCheck, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: S.of(context).only,
                  subtitle: '${S.of(context).on} ($counter)',
                  subtitleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  trailingText: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Изменить', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                      const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.chevron_right_rounded, size: 18, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      ),
                    ],
                  ),
                  value: 3,
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  inactiveIconColor: ChatifyColors.darkerGrey,
                  radioScale: 1.13,
                  onTrailingTap: () async {
                    final changed = await Navigator.push<bool>(context, createPageRoute(const ShareScreen()));

                    if (changed == true) {
                      _markAsChanged();
                    }
                  },
                ),
              ],
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
          _buildSettingSwitchTile(),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Делитесь в других приложениях',
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Автоматически делитесь статусом в историях ВКонтакте и Одноклассники. ',
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                      ),
                      TextSpan(
                        text: 'Перейти в центр аккаунтов',
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, height: 1.3),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _buildSwitchTile(
            icon: ChatifyVectors.vk,
            title: 'История ВКонтакте',
            value: _isHistoryVKEnabled,
            onChanged: (value) {
              setState(() {
                _isHistoryVKEnabled = value;
              });

              _markAsChanged();
            },
          ),
          _buildSwitchTile(
            icon: ChatifyVectors.ok,
            title: 'История в Одноклассниках',
            value: _isHistoryOKEnabled,
            onChanged: (value) {
              setState(() {
                _isHistoryOKEnabled = value;
              });

              _markAsChanged();
            },
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 8, bottom: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(S.of(context).changesAffectStatus, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitchTile() {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 27, right: 20, top: 10, bottom: 10),
          child: Row(
            children: [
              SvgPicture.asset(ChatifyVectors.forwardingArrow, width: 21, height: 21, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Разрешить делиться', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 3),
                    Text('Разрешите пользователям, которые видят ваш статус, делиться им и пересылать его.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomSwitch(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });

                  _markAsChanged();
                },
                switchWidth: 55,
                switchHeight: 33,
                thumbSize: 25,
                thumbPadding: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String icon, required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });

          onChanged(!value);
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 27, right: 20, top: 14, bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, width: 23, height: 23, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                        const SizedBox(width: 8),
                        CustomSwitch(
                          value: value,
                          onChanged: onChanged,
                          isPressed: isPressed,
                          switchWidth: 55,
                          switchHeight: 33,
                          thumbSize: 25,
                          thumbPadding: 3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
