import 'dart:io';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/forms/profile_form.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: ChatifyColors.white,
              boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
            ),
            child: AppBar(
              title: Text(S.of(context).profile, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
              titleSpacing: 0,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ProfileForm(
                  formKey: formKey,
                  user: widget.user,
                  image: _image,
                  status: widget.user.status,
                  onImagePicked: (imagePath) async {
                    setState(() {
                      _image = imagePath;
                    });

                    if (_image != null) {
                      await APIs.updateProfilePicture(File(_image!));

                      setState(() {
                        widget.user.image = APIs.me.image;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
