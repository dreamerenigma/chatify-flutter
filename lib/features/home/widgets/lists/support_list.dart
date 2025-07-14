import 'package:flutter/material.dart';
import '../../../bot/models/support_model.dart';
import '../../../bot/widgets/cards/support_card.dart';

class SupportList extends StatefulWidget {
  final List<SupportAppModel> supports;
  final Function(SupportAppModel) onSupportSelected;
  final SupportAppModel? selectedSupport;

  const SupportList({
    super.key,
    required this.supports,
    required this.onSupportSelected,
    this.selectedSupport,
  });

  @override
  State<SupportList> createState() => _SupportListState();
}

class _SupportListState extends State<SupportList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return widget.supports.isEmpty
      ? const SizedBox.shrink()
      : Column(
          children: widget.supports.map((support) {
            final isSelected = widget.selectedSupport?.id == support.id;

            return SupportCard(
              support: support,
              onSupportSelected: (_) {
                widget.onSupportSelected(support);
              },
              isSelected: isSelected,
            );
          }).toList(),
        );
  }
}
