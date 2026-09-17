import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../chat/models/user_status_model.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../widgets/buttons/status_fab.dart';
import '../widgets/dialogs/add_status_bottom_dialog.dart';
import '../widgets/texts/encryption_info_text.dart';
import '../widgets/widgets/status_header_widget.dart';

class UserStatusScreen extends StatefulWidget {
  final UserModel user;
  final UserStatusModel? userStatus;
  final String? statusImageUrl;

  const UserStatusScreen({
    super.key,
    required this.user,
    this.userStatus,
    required this.statusImageUrl,
  });

  @override
  State<UserStatusScreen> createState() => _UserStatusScreenState();
}

class _UserStatusScreenState extends State<UserStatusScreen> {
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
            title: Text(S.of(context).status, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: const StatusFAB(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusHeaderWidget(user: widget.user, userStatus: widget.userStatus, statusImageUrl: widget.statusImageUrl, profileImageUrl: widget.statusImageUrl, onAddStatus: () => showAddStatusBottomDialog(context)),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          const SizedBox(height: 16),
          EncryptionInfoText(firstText: S.of(context).statusUpdatesEncryption, linkText: S.of(context).endToEndEncryption, thirdText: 'Они исчезнуть через 24 часа'),
        ],
      ),
    );
  }
}
