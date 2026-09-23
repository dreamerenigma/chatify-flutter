import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../data/reserved_usernames_data.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/app_loaders.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/items/username_info_item.dart';
import '../../widgets/texts/marquee_text.dart';
import 'congratulation_username_screen.dart';

class ReserveUsernameScreen extends StatefulWidget {
  final UserModel user;

  const ReserveUsernameScreen({
    super.key,
    required this.user,
  });

  @override
  State<ReserveUsernameScreen> createState() => _ReserveUsernameScreenState();
}

class _ReserveUsernameScreenState extends State<ReserveUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isUsernameCreated = false;
  bool? _isUsernameAvailable;
  bool _isCheckingUsername = false;
  int _usernameCheckId = 0;
  Timer? _usernameCheckTimer;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameCheckTimer?.cancel();
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _suggestUsername() {
    final currentUsername = _usernameController.text.trim().toLowerCase();

    if (currentUsername.isEmpty) {
      return;
    }

    final suffixes = <String>['1', '7', '10', '21', '24', '77', '99', '123', '2026', 'x', 'xx', 'pro'];
    final suffix = suffixes[DateTime.now().millisecondsSinceEpoch % suffixes.length];
    final suggestion = '$currentUsername$suffix';

    _usernameController.value = TextEditingValue(text: suggestion, selection: TextSelection.collapsed(offset: suggestion.length));
  }

  void _onUsernameChanged() {
    setState(() {});
  }

  Future<void> _checkUsernameAvailability(String value) async {
    final username = value.trim().toLowerCase();

    _usernameCheckTimer?.cancel();

    final int checkId = ++_usernameCheckId;

    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = null;
        _isCheckingUsername = false;
      });
      return;
    }

    if (reservedUsernames.contains(username)) {
      setState(() {
        _isUsernameAvailable = false;
        _isCheckingUsername = false;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = null;
    });

    _usernameCheckTimer = Timer(
      const Duration(milliseconds: 400), () async {
        try {
          final snapshot = await APIs.firestore.collection('Users').where('username', isEqualTo: username).limit(1).get();

          if (!mounted || checkId != _usernameCheckId) {
            return;
          }

          setState(() {
            _isUsernameAvailable = snapshot.docs.isEmpty;
            _isCheckingUsername = false;
          });
        } catch (e) {
          if (!mounted || checkId != _usernameCheckId) {
            return;
          }

          setState(() {
            _isUsernameAvailable = null;
            _isCheckingUsername = false;
          });
        }
      },
    );
  }

  Future<void> _saveUsername() async {
    final username = _usernameController.text.trim().toLowerCase();

    if (username.isEmpty) {
      return;
    }

    if (reservedUsernames.contains(username)) {
      setState(() {
        _isUsernameAvailable = false;
        _isCheckingUsername = false;
      });
      return;
    }

    if (_isUsernameAvailable != true) {
      return;
    }

    setState(() {
      _isCheckingUsername = true;
    });

    final success = await APIs.updateUsername(username);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CongratulationUsernameScreen(user: widget.user)));
    } else {
      setState(() {
        _isCheckingUsername = false;
      });

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        'Не удалось сохранить имя пользователя',
        icon: SvgPicture.asset(ChatifyVectors.closeCircle, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
        iconColor: ChatifyColors.danger,
        position: SnackBarPositionType.bottom
      );
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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: SizedBox(width: double.infinity, child: MarqueeText(text: 'Зарезервируйте имя пользователя', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))),
          ),
        ),
      ),
      body: SafeArea(child: _isUsernameCreated ? _buildUsernameEditor(context) : _buildUsernameInfo(context)),
    );
  }

  Widget? _buildUsernameSuffixIcon() {
    if (_isCheckingUsername) {
      return Padding(padding: const EdgeInsets.all(14), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3)));
    }

    if (_isUsernameAvailable == true) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(ChatifyVectors.checkCircleFilled, width: 18, height: 18, colorFilter: ColorFilter.mode(ChatifyColors.green, BlendMode.srcIn)),
      );
    }

    if (_isUsernameAvailable == false) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(ChatifyVectors.warning, width: 16, height: 16, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn)),
      );
    }

    return null;
  }

  Widget _buildUsernameStatus() {
    if (_isCheckingUsername) {
      return const SizedBox.shrink();
    }

    if (_isUsernameAvailable == true) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, top: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Это имя пользователя доступно', style: TextStyle(color: ChatifyColors.green, fontSize: 13, fontWeight: FontWeight.w400)),
        ),
      );
    }

    if (_isUsernameAvailable == false) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, top: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Имя пользователя уже используется', style: TextStyle(color: ChatifyColors.danger, fontSize: 13, fontWeight: FontWeight.w400)),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildUsernameInfo(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ChatifyVectors.username, width: 120, height: 120),
            const SizedBox(height: 24),
            Text(
              'Скоро будут доступны имена пользователей. Зарезервируйте своё уже сегодня.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400, height: 1.35),
            ),
            const SizedBox(height: 28),
            UsernameInfoItem(
              icon: Icons.alternate_email_rounded,
              text: 'Имя пользователя поможет сохранить ваш номер телефона в тайне от людей, которые ещё не знают его.',
            ),
            const SizedBox(height: 14),
            UsernameInfoItem(
              svgIcon: ChatifyVectors.key,
              text: 'Вы можете добавить ключ, чтобы контролировать, кто может связаться с вами по имени пользователя.',
              linkText: 'Подробнее',
              onLinkTap: () {},
            ),
            const SizedBox(height: 16),
            _buildSocialButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameEditor(BuildContext context) {
    final bool canSave = _usernameController.text.trim().isNotEmpty && _isUsernameAvailable == true && !_isCheckingUsername;
    final bool isUsernameTaken = _isUsernameAvailable == false;
    final Color usernameColor = isUsernameTaken ? ChatifyColors.danger : colorsController.getColor(colorsController.selectedColorScheme.value);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onChanged: _checkUsernameAvailability,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: S.of(context).username,
                    labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    floatingLabelStyle: TextStyle(color: usernameColor, fontSize: ChatifySizes.fontSizeMd),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: usernameColor, width: 1)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    prefixIcon: const Icon(Icons.alternate_email_rounded, size: 26, color: ChatifyColors.darkGrey),
                    suffixIcon: _buildUsernameSuffixIcon(),
                  ),
                ),
                _buildUsernameStatus(),
                SizedBox(height: 20),
                _buildUsernameSuggestionButton(context),
              ],
            ),
          ),
        ),
        const Spacer(),
        CustomBottomButton(text: 'Сохранить', onTap: _saveUsername, enabled: canSave)
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: colorsController.getColor(colorsController.selectedColorScheme.value),
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              setState(() {
                _isUsernameCreated = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(child: Text('Создать имя пользователя', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: ChatifyColors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: ChatifyColors.softNight, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ChatifyVectors.vk,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value,), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Имя пользователя ВКонтакте',
                    style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: ChatifyColors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: ChatifyColors.softNight, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ChatifyVectors.ok,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value,), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Имя пользователя Одноклассники',
                    style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameSuggestionButton(BuildContext context) {
    if (_isUsernameAvailable != false || _isCheckingUsername) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: Material(
          color: ChatifyColors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: _suggestUsername,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: ChatifyColors.youngNight, width: 1)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'Предложить имя пользователя',
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
