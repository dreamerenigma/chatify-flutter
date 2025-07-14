import 'dart:developer';
import 'dart:io';
import 'package:yaml/yaml.dart';

void main() {
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecMap = loadYaml(pubspecContent) as Map;

  final version = pubspecMap['version'] as String;

  final versionParts = version.split('+');
  final versionString = versionParts[0];
  final buildNumber = versionParts[1];

  final versionFile = File('lib/version.dart');
  versionFile.writeAsStringSync('''
  // GENERATED CODE - DO NOT MODIFY BY HAND

  /// The name of the app.
  const String appName = 'Chatify';

  /// The current version of the app.
  const String appVersion = '$versionString';

  /// The current build number of the app.
  const String appBuildNumber = '$buildNumber';
  ''');

  log('version.dart has been generated!');
}
