import 'package:flutter/material.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../models/recent_call_model.dart';
import '../cards/recent_call_card.dart';

class RecentCallsList extends StatelessWidget {
  final List<RecentCallModel> calls;
  final Function(RecentCallModel)? onCallTap;

  const RecentCallsList({
    super.key,
    required this.calls,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 20, top: 20, bottom: 8),
          child: Text('Недавние', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w500)),
        ),
        ...calls.map((call) => RecentCallCard(call: call, onTap: () => onCallTap?.call(call))),
      ],
    );
  }
}
