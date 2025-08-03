import 'package:flutter/material.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

void showNoInternetConnectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: const Text('Не удалось выполнить звонок. Убедитесь, что ваше устройство подключено к Интернету, и повторите попытку.'),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ).copyWith(
            mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).ok, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
        ),
      ],
    ),
  );
}
