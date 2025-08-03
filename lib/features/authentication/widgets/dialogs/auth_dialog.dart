import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/urls/url_utils.dart';

Future<void> showAuthDialog(BuildContext context, Future<String> Function() getAuthUrl) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).googleAuthorization),
        content: FutureBuilder<String>(
          future: getAuthUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Text('${S.of(context).error}: ${snapshot.error}');
            } else {
              final authUrl = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).clickOnLinkToLogIn),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => UrlUtils.launchURL(authUrl),
                    child: Text(
                      authUrl,
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).close),
          ),
        ],
      );
    },
  );
}


