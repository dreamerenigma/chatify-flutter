import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  /// Utility function to launch a URL in the browser.
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
