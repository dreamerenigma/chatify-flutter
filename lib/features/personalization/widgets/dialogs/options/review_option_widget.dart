import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/authentication/widgets/buttons/custom_radio_button.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heroicons/heroicons.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../../utils/popups/custom_tooltip.dart';
import '../../../../authentication/models/country.dart';
import '../../../../authentication/widgets/lists/country_list.dart';
import '../../../../bot/models/support_model.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../group/models/group_model.dart';
import '../../../../home/widgets/dialogs/change_new_contact_dialog.dart';
import '../../../../home/widgets/dialogs/confirmation_dialog.dart';
import '../../../../home/widgets/dialogs/options/overlays/sounds_overlay_entry.dart';
import '../../../../home/widgets/dialogs/overlays/no_sound_overlay.dart';
import '../../../../home/widgets/dialogs/overlays/select_country_overlay.dart';
import '../../../../home/widgets/input/search_text_input.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../light_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../overlays/info_chat_support_app_overlay.dart';

class ReviewOptionWidget extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;
  final SupportAppModel? support;

  const ReviewOptionWidget({super.key, this.user, this.group, this.support});

  @override
  State<ReviewOptionWidget> createState() => _ReviewOptionWidgetState();
}

class _ReviewOptionWidgetState extends State<ReviewOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final LayerLink _noSoundLink = LayerLink();
  final LayerLink _soundDefaultLink = LayerLink();
  final audioPlayer = AudioPlayer();
  late TextEditingController _phoneController;
  final ValueNotifier<String> selectedFlagNotifier = ValueNotifier(ChatifyVectors.rus);
  final ValueNotifier<String> selectedCountryCodeNotifier = ValueNotifier('+7');
  bool _isInside = false;
  bool _isTappedNoSound = false;
  bool _isTappedSoundDefault = false;
  bool _isTappedSound = false;
  bool _isHoveredNoSoundNotify = false;
  bool _isHoveredSoundDefault = false;
  bool _isHoveredSound = false;
  bool isNoSoundDropDown = false;
  bool isSoundDefaultDropdown = false;
  bool isSoundNotifyTapped = false;
  bool _isExpanded = false;
  bool isFavorite = false;
  bool isNoSound = false;
  String selectedSoundOption = 'always';
  String lastSeen = '';
  String selectedReason = '';
  OverlayEntry? _noSoundOverlayEntry;
  OverlayEntry? _soundDefaultOverlayEntry;
  ValueNotifier<bool> isOverlayVisible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.support!.phoneNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.user != null) {
      final lastActiveTime = widget.user!.lastActive;

      if (lastSeen.isEmpty) {
        lastSeen = DateUtil.getLastActiveTime(
          context: context,
          lastActive: Timestamp.fromDate(lastActiveTime),
          hideLastSeenText: true,
          removeWasPrefix: true,
        );
      }
    } else {
      lastSeen = "Unknown";
    }
  }

  void _showNoSoundOverlay() {
    _hideNoSoundOverlay();
    isOverlayVisible.value = true;
    _toggleNoSound(selectedSoundOption);

    _noSoundOverlayEntry ??= NoSoundOverlayEntry.createNoSoundOverlayEntry(
      _noSoundLink,
      selectedSoundOption,
      _hideNoSoundOverlay,
      onSoundSelected: (selected) {
        setState(() {
          selectedSoundOption = selected;
        });
        _saveSelectedSoundNotify(selected);
        _toggleNoSound(selected);
      },
      true,
      overlayType: 'messages',
      overlayEntry: _noSoundOverlayEntry!,
    );

    Overlay.of(context).insert(_noSoundOverlayEntry!);
    isNoSoundDropDown = true;
  }

  void _hideNoSoundOverlay() {
    _noSoundOverlayEntry?.remove();
    _noSoundOverlayEntry = null;
    isNoSoundDropDown = false;
    isOverlayVisible.value = false;
  }

  void _showSoundDefaultOverlay() {
    _hideSoundDefaultOverlay();
    isOverlayVisible.value = true;
    _soundDefaultOverlayEntry = SoundsOverlayEntry.createSoundsOverlayEntry(
      _soundDefaultLink,
      selectedSoundOption,
      _hideSoundDefaultOverlay,
      onSoundSelected: (value, label) {
        setState(() {
          selectedSoundOption = value;
        });
        _saveSelectedSoundNotify(selectedSoundOption);
      },
      true,
      overlayType: 'messages',
    );
    Overlay.of(context).insert(_soundDefaultOverlayEntry!);
    isSoundDefaultDropdown = true;
  }

  void _hideSoundDefaultOverlay() {
    _soundDefaultOverlayEntry?.remove();
    _soundDefaultOverlayEntry = null;
    isSoundDefaultDropdown = false;
    isOverlayVisible.value = false;
  }

  void _toggleNoSoundsDropdown() {
    if (isNoSoundDropDown) {
      _hideNoSoundOverlay();
    } else {
      _showNoSoundOverlay();
    }
  }

  void _toggleSoundsDefaultDropdown() {
    if (isSoundDefaultDropdown) {
      _hideSoundDefaultOverlay();
    } else {
      _showSoundDefaultOverlay();
    }
  }

  void _saveSelectedSoundNotify(String selected) {
    final box = GetStorage();
    box.write('selectedSoundNotify', selected);
  }

  Future<void> handlePress(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(ChatifySounds.messageIncoming));
    } catch (e) {
      log('Error playing sound: $e');
    }

    if (!mounted) return;

    setState(() {
      _isTappedSound = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isTappedSound = false;
        });
      }
    });
  }

    void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _handleReasonChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedReason = newValue;
      });
    }
  }

  void _toggleNoSound(String selectedOption) {
    log('Selected Option: $selectedOption');
    setState(() {
      isNoSound = selectedOption != '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSupport = widget.support != null;
    final Color backgroundColor = isSupport ? colorsController.getColor(colorsController.selectedColorScheme.value) : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey);
    return ValueListenableBuilder<bool>(
      valueListenable: isOverlayVisible,
      builder: (context, isOverlay, child) {
        return AbsorbPointer(
          absorbing: isOverlay,
          child: CustomScrollbar(
            scrollController: _scrollController,
            isInsidePersonalizedOption: _isInside,
            onHoverChange: (bool isHovered) {
              setState(() {
                _isInside = isHovered;
              });
            },
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: backgroundColor,
                              backgroundImage: null,
                              child: Builder(
                                builder: (context) {
                                  final userImage = widget.user?.image;
                                  final imageUrl = (userImage?.isNotEmpty ?? false) ? userImage! : '';

                                  if (isSupport) {
                                    return SvgPicture.asset(ChatifyVectors.logoApp, width: 60, height: 60, color: context.isDarkMode ? ChatifyColors.white : null);
                                  }

                                  return CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    errorWidget: (context, url, error) => SvgPicture.asset(ChatifyVectors.newUser, width: 55, height: 55, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                                    imageBuilder: (context, imageProvider) => CircleAvatar(radius: 50, backgroundImage: imageProvider),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (widget.user != null)
                          Positioned(
                            right: 5,
                            top: -7,
                            child: Material(
                              color: ChatifyColors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (widget.user != null) {
                                    showChangeNewContactDialog(
                                      context,
                                      title: 'Изменение контакта',
                                      entity: widget.user,
                                      onCountrySelected: (String flagAssetPath, String countryCode) {},
                                      contentBuilder: (BuildContext context, void Function(void Function()) setState) {
                                        return Column(
                                          children: [
                                            _buildPhoneNumber("Номер телефона", widget.user!.phoneNumber),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    log('User is null');
                                  }
                                },
                                mouseCursor: SystemMouseCursors.basic,
                                splashColor: ChatifyColors.transparent,
                                highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
                                borderRadius: BorderRadius.circular(6),
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Icon(JamIcons.pencil, size: 21, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (widget.user != null || widget.support != null) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (widget.support?.name.isNotEmpty ?? false)
                                ? widget.support!.name
                                : (widget.user?.name.isNotEmpty ?? false)
                                  ? '${widget.user!.name}${widget.user!.surname.isNotEmpty ? ' ${widget.user!.surname}' : ''}'
                                  : '',
                              style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500),
                            ),
                            if ((widget.support?.name.isNotEmpty ?? false)) ...[
                              SizedBox(width: 6),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(ChatifyVectors.starburst, width: 25, height: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1, top: 2),
                                    child: SvgPicture.asset(ChatifyVectors.checkmark, width: 14, height: 14, color: ChatifyColors.white),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          [
                            if (widget.user != null) "~${widget.user!.name.split(' ').first}",
                            if (widget.support?.description != null && widget.support!.description.isNotEmpty) widget.support!.description
                          ].join(" · "),
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                        )
                      ] else ...[
                        Text('User data is unavailable', style: TextStyle(fontSize: 20)),
                      ],
                      const SizedBox(height: 24),
                      if (widget.user != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIconWithText(
                              label: "Видео",
                              icon: HeroIcon(HeroIcons.videoCamera, size: 20),
                            ),
                            SizedBox(width: 2),
                            _buildIconWithText(
                              label: "Аудио",
                              icon: SvgPicture.asset(ChatifyVectors.calls, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            ),
                          ],
                        ),
                      ] else if (widget.support != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildIconWithText(
                                label: "Добавить",
                                icon: SvgPicture.asset(ChatifyVectors.addCallUser, width: 28, height: 28, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.user != null) ...[
                            _buildInfoBlock("Был(-а)", lastSeen),
                            _buildInfoBlock("Сведения", widget.user!.about),
                            _buildInfoBlock("Номер телефона", widget.user!.phoneNumber),
                            _buildInfoBlock("Исчезающие сообщения", "Выкл."),
                            const SizedBox(height: 16),
                          ]
                            else if (widget.support != null) ...[
                          ],
                          if (widget.support != null) ...[
                            _buildInfo(),
                          ],
                          const SizedBox(height: 16),
                          _buildNotify(),
                          const SizedBox(height: 16),
                          _buildSoundNotify(context),
                          const SizedBox(height: 12),
                          Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                          const SizedBox(height: 2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.user != null || widget.group != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: _buildActionButton(
                                  text: isFavorite ? "Удалить из Избранного" : "Добавить в Избранное",
                                  message: isFavorite ? 'Удалить из Избранного' : 'Добавить в Избранное',
                                  onTap: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildActionButton(
                                      text: "Заблокировать",
                                      onTap: () {
                                        showConfirmationDialog(
                                          context: context,
                                          width: 500,
                                          title: 'Заблокировать компанию Chatify Support?',
                                          description: 'Эта компания больше не сможет вам звонить или отправлять сообщения. Причина блокировки:',
                                          cancelText: 'Отмена',
                                          confirmText: 'Заблокировать',
                                          confirmButton: false,
                                          onConfirm: () {},
                                          additionalWidget: StatefulBuilder(
                                            builder: (context, setState) {
                                              String localSelectedReason = selectedReason;

                                              void handleLocalChange(String? value) {
                                                setState(() {
                                                  localSelectedReason = value!;
                                                  _handleReasonChange(value);
                                                });
                                              }

                                              return Column(
                                                children: [
                                                  CustomRadioButton(
                                                    title: 'Не интересует',
                                                    imagePath: '',
                                                    value: 'Не интересует',
                                                    groupValue: localSelectedReason,
                                                    onChanged: handleLocalChange,
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                  ),
                                                  CustomRadioButton(
                                                    title: 'Спам',
                                                    imagePath: '',
                                                    value: 'Спам',
                                                    groupValue: localSelectedReason,
                                                    onChanged: handleLocalChange,
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                  ),
                                                  CustomRadioButton(
                                                    title: 'Слишком много сообщений',
                                                    imagePath: '',
                                                    value: 'Слишком много сообщений',
                                                    groupValue: localSelectedReason,
                                                    onChanged: handleLocalChange,
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                  ),
                                                  CustomRadioButton(
                                                    title: 'Нет причин',
                                                    imagePath: '',
                                                    value: 'Нет причин',
                                                    groupValue: localSelectedReason,
                                                    onChanged: handleLocalChange,
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      message: 'Заблокировать',
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: _buildActionButton(
                                      text: "Пожаловаться",
                                      textColor: ChatifyColors.buttonRed,
                                      onTap: () {
                                        showConfirmationDialog(
                                          context: context,
                                          width: 500,
                                          title: 'Отправка жалобы в Chatify',
                                          description: 'Последние 5 сообщений в этом чате будут пересланы в Chatify. Этот пользователь не узнает о том, что вы заблокировали его или подали на него жалобу.',
                                          cancelText: 'Отмена',
                                          confirmText: 'Пожаловаться',
                                          confirmButton: false,
                                          onConfirm: () {},
                                        );
                                      },
                                      message: 'Пожаловаться',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconWithText({required Widget icon, required String label}) {
    return Material(
      color: ChatifyColors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
          border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
        ),
        child: InkWell(
          onTap: () {
            showChangeNewContactDialog(
              context,
              title: 'Номер телефона',
              entity: widget.support,
              showDeleteIcon: false,
              contentBuilder: (context, setDialogState) => _buildAddPhoneNumber(
                controller: _phoneController,
                flagAssetPath: selectedFlagNotifier.value,
                iconAssetPath: ChatifyVectors.arrowDown,
                onCountrySelected: (flag, code) {
                  setDialogState(() {
                    selectedFlagNotifier.value = flag;
                    selectedCountryCodeNotifier.value = code;
                    _phoneController.text = code;
                  });
                },
                countries: countries,
              ),
            );
          },
          mouseCursor: SystemMouseCursors.basic,
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: 145,
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    String collapsedText = 'Это официальный чат Службы поддержки Chatify. Более двух миллиардов человек более чем в 180 странах используют Chatify,';
    String expandedText = '$collapsedText чтобы всегда и везде оставаться на связи с друзьями и близкими. Chatify — это бесплатное приложение для простого, безопасного и надежного обмена сообщениями и звонками, доступное на мобильных телефонах по всему миру.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Сообщения в этом чате могут быть сгенерированны ИИ.', style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300)),
            ),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  InfoChatSupportAppOverlay(context).show();
                },
                mouseCursor: SystemMouseCursors.basic,
                splashColor: ChatifyColors.transparent,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(FluentIcons.info_20_regular, size: 16, color: ChatifyColors.grey),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isExpanded ? expandedText : collapsedText,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
              maxLines: _isExpanded ? null : 4,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Скрыть' : 'Ещё',
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBlock(String title, String subtitle) {
    bool isDisappearingMessages = title == "Исчезающие сообщения";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
          SizedBox(height: 6),
          Row(
            children: [
              if (isDisappearingMessages)
              SvgPicture.asset(ChatifyVectors.timer, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              if (isDisappearingMessages) SizedBox(width: 8),
              isDisappearingMessages
                ? Text(subtitle, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300))
                : Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: ChatifyColors.info,
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                    ),
                    child: SelectableText(subtitle, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotify() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Уведомления", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
        const SizedBox(height: 4),
        CompositedTransformTarget(
          link: _noSoundLink,
          child: IntrinsicWidth(
            child: GestureDetector(
              onTap: _toggleNoSoundsDropdown,
              onLongPress: () {
                setState(() {
                  _isTappedNoSound = true;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  _isTappedNoSound = false;
                });
              },
              onLongPressUp: () {
                setState(() {
                  _isTappedNoSound = false;
                });
              },
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isHoveredNoSoundNotify = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isHoveredNoSoundNotify = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isTappedNoSound ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredNoSoundNotify
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                    borderRadius: isNoSoundDropDown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        isNoSound ? ChatifyVectors.notificationNone : ChatifyVectors.notification,
                        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                        width: 19,
                        height: 19,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text("Без звука", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                      )),
                      const SizedBox(width: 14),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(0, (_isTappedNoSound || isNoSoundDropDown) ? 2.0 : 0, 0),
                        child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoundNotify(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Звук уведомления", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
        const SizedBox(height: 4),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await handlePress(audioPlayer);
              },
              onLongPress: () {
                setState(() {
                  _isTappedSound = true;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  _isTappedSound = false;
                });
              },
              onLongPressUp: () {
                setState(() {
                  _isTappedSound = false;
                });
              },
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isHoveredSound = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isHoveredSound = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isTappedSound ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredSound
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                    borderRadius: isSoundNotifyTapped ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                  ),
                  child: SizedBox(
                    width: 40,
                    height: 30,
                    child: Icon(FluentIcons.play_20_regular, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 20),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            CompositedTransformTarget(
              link: _soundDefaultLink,
              child: GestureDetector(
                onTap: _toggleSoundsDefaultDropdown,
                onLongPress: () {
                  setState(() {
                    _isTappedSoundDefault = true;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    _isTappedSoundDefault = false;
                  });
                },
                onLongPressUp: () {
                  setState(() {
                    _isTappedSoundDefault = false;
                  });
                },
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHoveredSoundDefault = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveredSoundDefault = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isTappedSoundDefault ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredSoundDefault
                        ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                        : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                      borderRadius: isSoundDefaultDropdown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FluentIcons.music_note_2_24_regular, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 20),
                        SizedBox(width: 10),
                        Text('По умолчанию', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                        SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(0, (_isTappedSoundDefault || isSoundDefaultDropdown) ? 2.0 : 0, 0),
                          child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({required String text, VoidCallback? onTap, Color? textColor, EdgeInsetsGeometry? padding, required String message}) {
    return CustomTooltip(
      message: message,
      horizontalOffset: -65,
      child: Material(
        color: ChatifyColors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
          ),
          child: InkWell(
            onTap: onTap,
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(8),
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: textColor ?? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumber(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
          SizedBox(height: 12),
          Text(subtitle, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
        ],
      ),
    );
  }

  Widget _buildAddPhoneNumber({
  required TextEditingController controller,
  required String flagAssetPath,
  required String iconAssetPath,
  required void Function(String flagPath, String countryCode) onCountrySelected,
  required List<Country> countries,
}) {
  final GlobalKey selectCountryKey = GlobalKey();
  final selectedCountryNotifier = ValueNotifier<Country?>(null);
  bool isUserInteraction = false;

  controller.addListener(() {
    if (isUserInteraction) return;

    final input = controller.text;
    log('Controller text changed: $input');

    final matchedCountry = countries.firstWhere(
      (country) => input.startsWith(country.code),
      orElse: () => Country('', '', '', '', flagAssetPath),
    );

    log('Matched country: ${matchedCountry.name}, code: ${matchedCountry.code}');

    if (matchedCountry.code.isNotEmpty && selectedCountryNotifier.value?.code != matchedCountry.code) {
      selectedCountryNotifier.value = matchedCountry;
      log('Updated selected country: ${matchedCountry.name}');
    }
  });

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                log('Country flag clicked');
                final renderBox = selectCountryKey.currentContext?.findRenderObject();
                if (renderBox is RenderBox) {
                  final position = renderBox.localToGlobal(Offset.zero);

                  showSelectCountryOverlay(context, position, (Country selected) {
                    log('User selected country: ${selected.name}, code: ${selected.code}');
                    isUserInteraction = true;
                    onCountrySelected(selected.flag, selected.code);
                    controller.text = selected.code;
                    log('Updated controller text to: ${controller.text}');
                    selectedCountryNotifier.value = selected;
                    log('Selected country updated: ${selected.name}');
                    isUserInteraction = false;
                  });
                }
              },
              mouseCursor: SystemMouseCursors.basic,
              borderRadius: BorderRadius.circular(8),
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              child: Container(
                key: selectCountryKey,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<Country?>(
                      valueListenable: selectedCountryNotifier,
                      builder: (context, country, _) {
                        log('Rendering flag for country: ${country?.name}');
                        return SvgPicture.asset(country?.flag ?? flagAssetPath, width: 20, height: 20);
                      },
                    ),
                    const SizedBox(width: 12),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(iconAssetPath, width: 14, height: 14, color: ChatifyColors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: SearchTextInput(
                controller: controller,
                hintText: '',
                padding: EdgeInsets.zero,
                showPrefixIcon: false,
                showSuffixIcon: false,
                showDialPad: false,
                showTooltip: false,
                showAdditionalSuffixIcon: true,
                allowOnlyDigits: true,
                hideClearIcon: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Этот номер телефона зарегистрирован в Chatify', style: TextStyle(fontSize: 12, color: ChatifyColors.grey)),
      ],
    ),
  );
}

}
