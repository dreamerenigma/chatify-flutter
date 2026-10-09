import 'dart:convert';
import 'dart:developer';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import '../../../features/chat/models/link_preview_model.dart';
import 'package:charset/charset.dart';

class LinkPreviewService {
  Future<LinkPreviewModel?> fetchPreview(String url) async {
    try {
      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
          'AppleWebKit/537.36',
      });

      if (response.statusCode < 200 || response.statusCode >= 400) {
        return null;
      }

      log('LINK PREVIEW STATUS: ${response.statusCode}');
      log('LINK PREVIEW CONTENT-TYPE: ${response.headers['content-type']}');
      log('LINK PREVIEW CONTENT-ENCODING: ${response.headers['content-encoding']}');

      final bodyStart = response.bodyBytes.take(300).toList();

      log('LINK PREVIEW BYTES: ${bodyStart.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');

      final contentType = response.headers['content-type'] ?? '';
      final charsetMatch = RegExp(r'charset=([a-zA-Z0-9_-]+)', caseSensitive: false).firstMatch(contentType);
      final charsetName = charsetMatch?.group(1)?.toLowerCase();

      final html = switch (charsetName) {
        'windows-1251' || 'cp1251' => windows1251.decode(response.bodyBytes),
        'utf-8' || null => utf8.decode(response.bodyBytes, allowMalformed: true),
        _ => utf8.decode(response.bodyBytes, allowMalformed: true),
      };

      final document = html_parser.parse(html);

      String? getMeta(String property) {
        return document.querySelector('meta[property="$property"]')?.attributes['content'];
      }

      String? getMetaName(String name) {
        return document.querySelector('meta[name="$name"]')?.attributes['content'];
      }

      final title = getMeta('og:title') ?? document.querySelector('title')?.text.trim();

      if (title == null || title.isEmpty) {
        return null;
      }

      final description = getMeta('og:description') ?? getMetaName('description');
      final imageUrl = getMeta('og:image');
      final favicon = document.querySelector('link[rel="icon"]')?.attributes['href'] ?? document.querySelector('link[rel="shortcut icon"]')?.attributes['href'];

      return LinkPreviewModel(url: url, title: title, description: description, imageUrl: _resolveUrl(uri, imageUrl), faviconUrl: _resolveUrl(uri, favicon));
    } catch (e, st) {
      log('LINK PREVIEW ERROR: $e');
      log('$st');
      return null;
    }
  }

  String? _resolveUrl(Uri base, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);

    if (uri == null) {
      return null;
    }

    return uri.hasScheme ? uri.toString() : base.resolveUri(uri).toString();
  }
}
