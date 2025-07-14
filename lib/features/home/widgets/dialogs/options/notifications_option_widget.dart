import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../common/widgets/switches/custom_switch.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import 'overlays/banner_overlay_entry.dart';
import 'overlays/sounds_overlay_entry.dart';

class NotificationsOptionWidget extends StatefulWidget {
  const NotificationsOptionWidget({super.key});

  @override
  State<NotificationsOptionWidget> createState() => _NotificationsOptionWidgetState();
}

class _NotificationsOptionWidgetState extends State<NotificationsOptionWidget> {
  bool isBannerNotifyDropdown = false;
  bool isIconNotifyDropdown = false;
  bool isSoundDropdown = false;
  bool isMessagesDropdown = false;
  bool isGroupsDropdown = false;
  bool _isTappedBanner = false;
  bool _isTappedIcon = false;
  bool isPressed = false;
  bool _isInside = false;
  bool _isMessages = false;
  bool _isCalls = false;
  bool _isReactions = false;
  bool _isStatusReactions = false;
  bool _isTextPreview = false;
  bool _isMediaPreview = false;
  bool _isBannerSelected = false;
  bool _isIconSelected = false;
  bool _isFading = false;
  bool _isHoveredBanner = false;
  bool _isHoveredIcon = false;
  bool _isHoveredMessages = false;
  bool _isHoveredGroups = false;
  bool _isHoveredSoundMessages = false;
  bool _isTappedSoundMessages = false;
  bool _isHoveredSoundGroups = false;
  bool _isTappedSoundGroups = false;
  bool isSoundNotifyTapped = false;
  final bool _isTappedMessage = false;
  final bool _isTappedSound = false;
  final bool _isHoveredSound = false;
  final LayerLink _bannerNotifyLink = LayerLink();
  final LayerLink _iconNotifyLink = LayerLink();
  final LayerLink _soundsLinkMessages = LayerLink();
  final LayerLink _soundsLinkGroups = LayerLink();
  final GetStorage _storage = GetStorage();
  final ScrollController _scrollController = ScrollController();
  final audioPlayer = AudioPlayer();
  String selectedBannerOption = 'always';
  String selectedIconOption = 'always';
  String selectedSoundLabel = 'По умолчанию';
  String selectedSoundOptionMessages = 'default';
  String selectedSoundOptionGroups = 'default';
  OverlayEntry? _bannerOverlayEntry;
  OverlayEntry? _iconOverlayEntry;
  OverlayEntry? _soundsOverlayEntry;
  ValueNotifier<bool> isOverlayVisible = ValueNotifier(false);

  final Map<String, String> optionTexts = {
    'always': 'Всегда',
    'never': 'Никогда',
    'only': 'Только при открытом приложении',
  };

  final Map<String, String> optionSoundTexts = {
    'no': 'Нет',
    'default': 'По умолчанию',
    'warning': 'Предупреждение',
  };

  @override
  void initState() {
    super.initState();
    selectedBannerOption = _storage.read('selectedBannerNotify') ?? 'defaultOption';
    selectedIconOption = _storage.read('selectedIconNotify') ?? 'defaultOption';
    selectedSoundOptionMessages = _storage.read('selectedSoundMessagesNotify') ?? 'defaultOption';
    selectedSoundOptionGroups = _storage.read('selectedSoundGroupsNotify') ?? 'defaultOption';
    _isMessages = _storage.read('isMessages') ?? false;
    _isCalls = _storage.read('isCalls') ?? false;
    _isReactions = _storage.read('isReactions') ?? false;
    _isStatusReactions = _storage.read('isStatusReactions') ?? false;
    _isTextPreview = _storage.read('isTextPreview') ?? false;
    _isMediaPreview = _storage.read('isMediaPreview') ?? false;
  }

  @override
  void dispose() {
    _hideBannerNotifyOverlay();
    _hideIconNotifyOverlay();
    _hideSoundOverlay(isMessages: _isMessages);
    super.dispose();
  }

  void _saveSwitchState() {
    _storage.write('isMessages', _isMessages);
    _storage.write('isCalls', _isCalls);
    _storage.write('isReactions', _isReactions);
    _storage.write('isStatusReactions', _isStatusReactions);
    _storage.write('isTextPreview', _isTextPreview);
    _storage.write('isMediaPreview', _isMediaPreview);
  }

  void _showBannerNotifyOverlay() {
    _hideBannerNotifyOverlay();
    _bannerOverlayEntry = BannerOverlayEntry.createBannerOverlayEntry(
      _bannerNotifyLink,
      selectedBannerOption,
      _toggleBannerNotifyDropdown,
      onNotifySelected: (selected) {
        setState(() {
          selectedBannerOption = selected;
        });
        _saveSelectedBannerNotify(selected);
      },
      overlayType: 'banner',
    );
    Overlay.of(context).insert(_bannerOverlayEntry!);
    isBannerNotifyDropdown = true;
  }

  void _hideBannerNotifyOverlay() {
    _bannerOverlayEntry?.remove();
    _bannerOverlayEntry = null;
    isBannerNotifyDropdown = false;
  }

  void _showIconNotifyOverlay() {
    _hideIconNotifyOverlay();
    _iconOverlayEntry = BannerOverlayEntry.createBannerOverlayEntry(
      _iconNotifyLink,
      selectedIconOption,
      _toggleIconNotifyDropdown,
      onNotifySelected: (selected) {
        setState(() {
          selectedIconOption = selected;
        });
        _saveSelectedIconNotify(selected);
      },
      overlayType: 'icon',
    );
    Overlay.of(context).insert(_iconOverlayEntry!);
    isIconNotifyDropdown = true;
  }

  void _hideIconNotifyOverlay() {
    _iconOverlayEntry?.remove();
    _iconOverlayEntry = null;
    isIconNotifyDropdown = false;
  }

  void _showSoundOverlay({required LayerLink layerLink, required bool isMessages}) {
    setState(() {
      if (isMessages) {
        isMessagesDropdown = true;
      } else {
        isGroupsDropdown = true;
      }
      isSoundDropdown = true;
    });

    isOverlayVisible.value = true;

    String selectedSoundOptionForOverlay = isMessages ? selectedSoundOptionMessages : selectedSoundOptionGroups;

    _soundsOverlayEntry = SoundsOverlayEntry.createSoundsOverlayEntry(
      layerLink,
      selectedSoundOptionForOverlay,
      () => _toggleSoundsDropdown(layerLink: layerLink, isMessages: isMessages),
      onSoundSelected: (value, label) {
        setState(() {
          if (isMessages) {
            selectedSoundOptionMessages = value;
          } else {
            selectedSoundOptionGroups = value;
          }
          selectedSoundLabel = label;
        });
        _saveSelectedSoundNotify(value, isMessages: isMessages);
      },
      true,
      overlayType: isMessages ? 'messages' : 'groups',
    );

    Overlay.of(context).insert(_soundsOverlayEntry!);
  }

  void _hideSoundOverlay({required bool isMessages}) {
    setState(() {
      if (isMessages) {
        isMessagesDropdown = false;
      } else {
        isGroupsDropdown = false;
      }
      isSoundDropdown = false;
    });
    _soundsOverlayEntry?.remove();
    _soundsOverlayEntry = null;
    isOverlayVisible.value = false;
  }

  void _toggleBannerNotifyDropdown() {
    if (isBannerNotifyDropdown) {
      _hideBannerNotifyOverlay();
    } else {
      _showBannerNotifyOverlay();
    }
  }

  void _toggleIconNotifyDropdown() {
    if (isIconNotifyDropdown) {
      _hideIconNotifyOverlay();
    } else {
      _showIconNotifyOverlay();
    }
  }

  void _toggleSoundsDropdown({required LayerLink layerLink, required bool isMessages}) {
    if (isSoundDropdown) {
      _hideSoundOverlay(isMessages: isMessages);
    } else {
      setState(() {
        if (isMessages) {
          isMessagesDropdown = true;
        } else {
          isGroupsDropdown = true;
        }
      });
      _showSoundOverlay(layerLink: layerLink, isMessages: isMessages);
    }
  }

  void _toggleSelection(String containerType) {
    setState(() {
      if (containerType == 'banner' && !_isBannerSelected) {
        _isBannerSelected = true;
        _isIconSelected = false;
      } else if (containerType == 'icon' && !_isIconSelected) {
        _isIconSelected = true;
        _isBannerSelected = false;
      }
      _isFading = false;

      Future.delayed(Duration(seconds: 500), () {
        setState(() {
          if (containerType == 'banner') {
            _isBannerSelected = false;
          } else if (containerType == 'icon') {
            _isIconSelected = false;
          }
          _isFading = true;
        });
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (containerType == 'banner') {
            _isBannerSelected = false;
          } else if (containerType == 'icon') {
            _isIconSelected = false;
          }
          _isFading = false;
        });
      });
    });
  }

  void _saveSelectedBannerNotify(String selected) {
    final box = GetStorage();
    box.write('selectedBannerNotify', selected);
  }

  void _saveSelectedIconNotify(String selected) {
    final box = GetStorage();
    box.write('selectedIconNotify', selected);
  }

  void _saveSelectedSoundNotify(String selected, {required bool isMessages}) {
    final box = GetStorage();

    if (isMessages) {
      box.write('selectedSoundMessagesNotify', selected);
    } else {
      box.write('selectedSoundGroupsNotify', selected);
    }
  }

  Future<void> handlePress(AudioPlayer audioPlayer, bool isMessages) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(ChatifySounds.messageIncoming));
    } catch (e) {
      log('Error playing sound: $e');
    }

    if (!mounted) return;

    setState(() {
      if (isMessages) {
        _isTappedSoundGroups = true;
      } else {
        _isTappedSoundGroups = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          if (isMessages) {
            _isTappedSoundMessages = false;
          } else {
            _isTappedSoundMessages = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Уведомления", style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBannerNotify(),
                    const SizedBox(width: 12),
                    _buildIconNotify(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isBannerSelected && !_isFading ? (context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.black) : ChatifyColors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedOpacity(
                    opacity: _isBannerSelected && !_isFading ? 0.5 : 1.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Показывать баннерные уведомления", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CompositedTransformTarget(
                            link: _bannerNotifyLink,
                            child: GestureDetector(
                              onTap: _toggleBannerNotifyDropdown,
                              onLongPress: () {
                                setState(() {
                                  _isTappedBanner = true;
                                });
                              },
                              onLongPressEnd: (_) {
                                setState(() {
                                  _isTappedBanner = false;
                                });
                              },
                              onLongPressUp: () {
                                setState(() {
                                  _isTappedBanner = false;
                                });
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _isHoveredBanner = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _isHoveredBanner = false;
                                  });
                                },
                                child: Container(
                                  height: 33,
                                  decoration: BoxDecoration(
                                    color: _isTappedBanner ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredBanner
                                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                    borderRadius: isBannerNotifyDropdown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 4),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              selectedBannerOption == 'only'
                                                ? IntrinsicWidth(
                                                    child: Text(
                                                      optionTexts[selectedBannerOption] ?? 'Только при открытом приложении',
                                                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                                    ),
                                                  )
                                                :
                                                SizedBox(
                                                  width: 125,
                                                  child: Text(
                                                    optionTexts[selectedBannerOption] ?? 'Всегда',
                                                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 50),
                                            transform: Matrix4.translationValues(0, (_isTappedBanner || isBannerNotifyDropdown) ? 2.0 : 0, 0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isIconSelected && !_isFading ? (context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.black) : ChatifyColors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedOpacity(
                    opacity: _isIconSelected && !_isFading ? 0.5 : 1.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Показывать значок уведомлений на панели задач", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CompositedTransformTarget(
                            link: _iconNotifyLink,
                            child: GestureDetector(
                              onTap: _toggleIconNotifyDropdown,
                              onLongPress: () {
                                setState(() {
                                  _isTappedIcon = true;
                                });
                              },
                              onLongPressEnd: (_) {
                                setState(() {
                                  _isTappedIcon = false;
                                });
                              },
                              onLongPressUp: () {
                                setState(() {
                                  _isTappedIcon = false;
                                });
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _isHoveredIcon = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _isHoveredIcon = false;
                                  });
                                },
                                child: Container(
                                  height: 33,
                                  decoration: BoxDecoration(
                                    color: _isTappedIcon ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredIcon
                                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                    borderRadius: isIconNotifyDropdown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              selectedIconOption == 'only'
                                                ? IntrinsicWidth(
                                                    child: Text(
                                                      optionTexts[selectedIconOption] ?? 'Только при открытом приложении',
                                                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: 125,
                                                    child: Text(
                                                      optionTexts[selectedIconOption] ?? 'Всегда',
                                                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 50),
                                            transform: Matrix4.translationValues(0, (_isTappedIcon || isIconNotifyDropdown) ? 2.0 : 0, 0),
                                            child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
              ),
              const SizedBox(height: 15),
              _buildSwitchOption(
                labelText: 'Сообщения',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isMessages,
                onChanged: (bool value) {
                  setState(() {
                    _isMessages = value;
                  });
                },
              ),
              _buildSwitchOption(
                labelText: 'Звонки',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isCalls,
                onChanged: (bool value) {
                  setState(() {
                    _isCalls = value;
                  });
                },
              ),
              _buildSwitchOption(
                labelText: 'Реакции',
                additionalText: 'Показывать уведомления о реакциях на отправленные вами сообщения',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isReactions,
                onChanged: (bool value) {
                  setState(() {
                    _isReactions = value;
                  });
                },
              ),
              _buildSwitchOption(
                labelText: 'Реакции на статус',
                additionalText: 'Показывать уведомления об отметках "Нравится" к статусу',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isStatusReactions,
                onChanged: (bool value) {
                  setState(() {
                    _isStatusReactions = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
              ),
              const SizedBox(height: 5),
              _buildSwitchOption(
                labelText: 'Предпросмотр текста',
                additionalText: 'Показывать текст сообщений в окне уведомлений',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isTextPreview,
                onChanged: (bool value) {
                  setState(() {
                    _isTextPreview = value;
                  });
                },
              ),
              _buildSwitchOption(
                labelText: 'Предпросмотр медиа',
                additionalText: 'Показывать изображения медиа в окне уведомлений о новых сообщениях',
                stateTextOn: 'Вкл.',
                stateTextOff: 'Выкл.',
                initialValue: _isMediaPreview,
                onChanged: (bool value) {
                  setState(() {
                    _isMediaPreview = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Звуки уведомлений', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Сообщения", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              ),
              _buildSoundNotify(
                context,
                layerLink: _soundsLinkMessages,
                isHovered: _isHoveredMessages,
                isDropdownVisible: isMessagesDropdown,
                onHoverChange: (val) => setState(() => _isHoveredMessages = val),
                onDropdownChange: (val) {
                  setState(() {
                    isMessagesDropdown = val;
                    _toggleSoundsDropdown(layerLink: _soundsLinkMessages, isMessages: true);
                  });
                },
                isMessages: true,
                selectedSoundOption: selectedSoundOptionMessages,
                isHoveredSound: _isHoveredSoundMessages,
                isTappedSound: _isTappedSoundMessages,
                onHoveredSoundChange: (val) => setState(() => _isHoveredSoundMessages = val),
                onTappedSoundChange: (val) => setState(() => _isTappedSoundMessages = val),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Группы", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              ),
              _buildSoundNotify(
                context,
                layerLink: _soundsLinkGroups,
                isHovered: _isHoveredGroups,
                isDropdownVisible: isGroupsDropdown,
                onHoverChange: (val) => setState(() => _isHoveredGroups = val),
                onDropdownChange: (val) {
                  setState(() {
                    isGroupsDropdown = val;
                    _toggleSoundsDropdown(layerLink: _soundsLinkGroups, isMessages: false);
                  });
                },
                isMessages: false,
                selectedSoundOption: selectedSoundOptionGroups,
                isHoveredSound: _isHoveredSoundGroups,
                isTappedSound: _isTappedSoundGroups,
                onHoveredSoundChange: (val) => setState(() => _isHoveredSoundGroups = val),
                onTappedSoundChange: (val) => setState(() => _isTappedSoundGroups = val),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerNotify() {
    return GestureDetector(
      onTap: () => _toggleSelection('banner'),
      child: Container(
        width: 145,
        height: 95,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 75,
                        height: 23,
                        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width: 13, height: 13, decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white, borderRadius: BorderRadius.circular(2))),
                              SizedBox(width: 3),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 1.7,
                                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white, borderRadius: BorderRadius.circular(4)),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    width: 43,
                                    height: 1.7,
                                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white, borderRadius: BorderRadius.circular(4)),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    width: 35,
                                    height: 1.7,
                                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white, borderRadius: BorderRadius.circular(4)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.buttonLightGrey : ChatifyColors.grey,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconNotify() {
    return GestureDetector(
      onTap: () => _toggleSelection('icon'),
      child: Container(
        width: 145,
        height: 95,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.buttonLightGrey : ChatifyColors.grey,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.white, borderRadius: BorderRadius.circular(4)),
                      child: Center(child: Image.asset(ChatifyImages.logoBlue, width: 20, height: 20)),
                    ),
                    Positioned(
                      top: -2,
                      right: -7,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                        child: Center(child: Text('2', style: TextStyle(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, fontSize: 11, fontWeight: FontWeight.w400))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption({
    required String labelText,
    required String stateTextOn,
    required String stateTextOff,
    required bool initialValue,
    required ValueChanged<bool> onChanged,
    String? additionalText,
  }) {
    bool isSwitchOn = initialValue;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left,
                ),
                if (additionalText != null)
                Text(additionalText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200), textAlign: TextAlign.left),
              ],
            ),
          ),
          SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isSwitchOn ? stateTextOn : stateTextOff, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              const SizedBox(width: 14),
              CustomSwitch(
                value: isSwitchOn,
                onChanged: (bool value) {
                  setState(() {
                    isSwitchOn = value;
                    onChanged(value);
                    _saveSwitchState();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundNotify(
    BuildContext context, {
    required LayerLink layerLink,
    required bool isHovered,
    required bool isDropdownVisible,
    required ValueChanged<bool> onHoverChange,
    required ValueChanged<bool> onDropdownChange,
    required bool isMessages,
    required bool isHoveredSound,
    required bool isTappedSound,
    required ValueChanged<bool> onHoveredSoundChange,
    required ValueChanged<bool> onTappedSoundChange,
    required String selectedSoundOption,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: selectedSoundOption == 'no' ? null : () async {
              await handlePress(audioPlayer, isMessages);
            },
            onLongPress: selectedSoundOption == 'no' ? null : () => onTappedSoundChange(true),
            onLongPressEnd: (_) => onTappedSoundChange(false),
            onLongPressUp: () => onTappedSoundChange(false),
            child: MouseRegion(
              onEnter: (_) {
                if (selectedSoundOption != 'no') onHoveredSoundChange(true);
              },
              onExit: (_) {
                if (selectedSoundOption != 'no') onHoveredSoundChange(false);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedSoundOption == 'no'
                      ? (context.isDarkMode ? ChatifyColors.softNight.withAlpha(100) : ChatifyColors.grey.withAlpha(50))
                      : _isTappedSound
                      ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100))
                      : _isHoveredSound
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                  borderRadius: isSoundNotifyTapped
                      ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
                      : BorderRadius.circular(6),
                  border: Border.all(
                    color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  ),
                ),
                child: SizedBox(
                  width: 40,
                  height: 30,
                  child: Icon(
                    FluentIcons.play_20_regular,
                    color: selectedSoundOption == 'no' ? (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black.withAlpha(100)) : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CompositedTransformTarget(
            link: layerLink,
            child: GestureDetector(
              onTap: () => onDropdownChange(!isDropdownVisible),
              onLongPress: () => onDropdownChange(true),
              onLongPressEnd: (_) => onDropdownChange(false),
              onLongPressUp: () => onDropdownChange(false),
              child: MouseRegion(
                onEnter: (_) => onHoverChange(true),
                onExit: (_) => onHoverChange(false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDropdownVisible ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHovered
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(FluentIcons.music_note_2_24_regular, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 20),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          selectedSoundOption.startsWith('ChatifySounds.notify')
                            ? IntrinsicWidth(
                            child: Text('Предупреждение ${selectedSoundOption.replaceAll(RegExp(r'\D'), '')}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)))
                              : selectedSoundOption == 'default'
                              ? SizedBox(width: 95, child: Text('По умолчанию', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)))
                              : SizedBox(width: 95, child: Text(optionSoundTexts[selectedSoundOption] ?? 'По умолчанию', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 50),
                        transform: Matrix4.translationValues(0, (_isTappedMessage || isDropdownVisible) ? 2 : 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
