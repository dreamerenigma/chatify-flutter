class AppSchemeAssets {
  static const Map<String, int> schemeMap = {'red': 0, 'green': 1, 'blue': 2, 'orange': 3};

  static int mapSchemeToIndex(String scheme) {
    return schemeMap[scheme.toLowerCase().trim()] ?? 0;
  }

  static String getAsset({required int schemeIndex, required List<String> assets}) {
    if (schemeIndex < 0 || schemeIndex >= assets.length) {
      return assets.first;
    }

    return assets[schemeIndex];
  }
}
