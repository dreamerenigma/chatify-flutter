import 'package:flutter/material.dart';
import '../../../bot/models/info_app_model.dart';
import '../../../bot/widgets/cards/info_app_card.dart';

class InfosAppList extends StatefulWidget {
  final List<InfoAppModel> infosApp;
  final Function(InfoAppModel) onInfoAppSelected;
  final InfoAppModel? selectedInfoApp;

  const InfosAppList({
    super.key,
    required this.infosApp,
    required this.onInfoAppSelected,
    this.selectedInfoApp,
  });

  @override
  State<InfosAppList> createState() => _InfosAppListState();
}

class _InfosAppListState extends State<InfosAppList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return widget.infosApp.isEmpty
      ? const SizedBox.shrink()
      : Column(
          children: widget.infosApp.map((infoApp) {
            final isSelected = widget.selectedInfoApp?.id == infoApp.id;

            return InfoAppCard(
              infoApp: infoApp,
              onInfoAppSelected: (_) {
                widget.onInfoAppSelected(infoApp);
              },
              isSelected: isSelected,
            );
          }).toList(),
        );
  }
}
