import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../home/widgets/input/search_text_input.dart';

class GroupsOptionWidget extends StatefulWidget {
  const GroupsOptionWidget({super.key});

  @override
  State<GroupsOptionWidget> createState() => _GroupsOptionWidgetState();
}

class _GroupsOptionWidgetState extends State<GroupsOptionWidget> {
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Общие группы (0)', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
          child: SearchTextInput(
            hintText: '',
            controller: groupController,
            enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
            padding: EdgeInsets.zero,
            showPrefixIcon: true,
            showSuffixIcon: true,
            showDialPad: false,
            showTooltip: false,
          ),
        ),
      ],
    );
  }
}
