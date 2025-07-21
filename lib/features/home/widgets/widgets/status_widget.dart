import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/controllers/user_controller.dart';

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final GlobalKey _statusPrivacyKey = GlobalKey();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).status, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
                  if (kIsWeb)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        tooltip: 'Help',
                        onPressed: () {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(1000, 100, 0, 0),
                            items: [
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(Icons.photo_camera, size: 20),
                                    SizedBox(width: 8),
                                    Text('Фото и видео'),
                                  ],
                                ),
                                onTap: () {

                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(Icons.text_fields, size: 20),
                                    SizedBox(width: 8),
                                    Text('Текст'),
                                  ],
                                ),
                                onTap: () {

                                },
                              ),
                            ],
                          );
                        },
                      ),
                      IconButton(
                        key: _statusPrivacyKey,
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'More',
                        onPressed: () {
                          final RenderBox renderBox = _statusPrivacyKey.currentContext?.findRenderObject() as RenderBox;
                          final position = renderBox.localToGlobal(Offset.zero);

                          showMenu(
                            context: context,
                            color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                            position: RelativeRect.fromLTRB(
                              position.dx,
                              position.dy,
                              position.dx + renderBox.size.width,
                              0,
                            ),
                            items: [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: const [
                                    Icon(Icons.privacy_tip, size: 20),
                                    SizedBox(width: 8),
                                    Text('Status Privacy'),
                                  ],
                                ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ).then((value) {
                            if (value == 1) {
                              // Ждём, чтобы меню успело закрыться
                              Future.delayed(Duration(milliseconds: 100), () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Status Privacy'),
                                    content: const Text('Настройки конфиденциальности статуса.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Закрыть'),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    onTap: () {},
                    mouseCursor: SystemMouseCursors.basic,
                    splashColor: ChatifyColors.transparent,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: userController.currentUser.image.isNotEmpty ? NetworkImage(userController.currentUser.image) : null,
                            radius: 24,
                            backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            child: userController.currentUser.image.isEmpty ? SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 30, height: 30) : null,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).myStatus, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              SizedBox(height: 2),
                              Text(S.of(context).noUpdates, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
              child: Text(S.of(context).noNewStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
            ),
          ],
        ),
      ),
    );
  }
}
