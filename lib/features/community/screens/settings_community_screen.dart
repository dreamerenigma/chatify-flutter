import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class SettingsCommunityScreen extends StatefulWidget {
  const SettingsCommunityScreen({super.key});

  @override
  SettingsCommunityScreenState createState() => SettingsCommunityScreenState();
}

class SettingsCommunityScreenState extends State<SettingsCommunityScreen> {
  String _selectedNewUserOption = 'Только админы';
  String _selectedNewGroupOption = 'Все';

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1 * 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text('Настройки сообщества',
              style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
            elevation: 1,
          ),
        ),
      ),
      body: _permissionsCommunity(context),
    );
  }

  Widget _permissionsCommunity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            'Разрешения сообщества',
            style: TextStyle(
                fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            _showBottomSheetDialogNewUser(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Кто может добавлять новых участников',
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedNewUserOption,
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            _showBottomSheetDialogNewGroups(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Кто может добавлять в новые группы',
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedNewGroupOption,
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheetDialogNewUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
                  child: Text(
                    'Кто может добавлять новых участников',
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _buildRadioOption(
                context,
                title: 'Все',
                description:
                'Добавлять других участников могут все участники сообщества.',
                groupValue: _selectedNewUserOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewUserOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                context,
                title: 'Только админы',
                description:
                'Добавлять других участников могут только админы групп и сообществ.',
                groupValue: _selectedNewUserOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewUserOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheetDialogNewGroups(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text(
                    'Кто может добавлять новые группы',
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeMd,
                      ),
                      children: [
                        const TextSpan(
                          text:
                          'Участники всегда могут предлагать группы на подтверждение админом. Админы сообщества могут удалять любые группы. ',
                        ),
                        TextSpan(
                          text: 'Подробнее',
                          style: const TextStyle(color: ChatifyColors.blue, decoration: TextDecoration.none),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            _launchURL(Uri.parse('https://faq.chatify.ru'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildRadioOption(
                context,
                title: 'Все',
                description: 'Все участники сообщества могут добавлять группы',
                groupValue: _selectedNewGroupOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewGroupOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                context,
                title: 'Только админы сообщества',
                description:
                'Только админы сообщества могут добавлять группы. Участники могут предлагать группы на рассмотрение админам.',
                groupValue: _selectedNewGroupOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewGroupOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioOption(
      BuildContext context, {
        required String title,
        required String description,
        required String groupValue,
        required ValueChanged<String?> onChanged,
      }) {
    return InkWell(
      onTap: () {
        onChanged(title);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: title,
            groupValue: groupValue,
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
