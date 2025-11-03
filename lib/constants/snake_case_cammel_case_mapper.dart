extension SnakeCaseCamelCaseMapper on Map<String, dynamic> {
  /// Converts snake_case keys to camelCase.
  Map<String, dynamic> normalizeKeys({bool deep = false}) {
    return map((key, value) {
      final normalizedKey = key.replaceAllMapped(
        RegExp(r'_([a-z])'),
        (m) => m.group(1)!.toUpperCase(),
      );
      final normalizedValue = deep && value is Map<String, dynamic>
          ? value.normalizeKeys(deep: true)
          : value;
      return MapEntry(normalizedKey, normalizedValue);
    });
  }

  /// Converts camelCase keys to snake_case.
  Map<String, dynamic> toSnakeCase({bool deep = false}) {
    return map((key, value) {
      final snakeKey = key
          .replaceAllMapped(
            RegExp(r'([a-z0-9])([A-Z])'),
            (m) => '${m[1]}_${m[2]}',
          )
          .toLowerCase();
      final snakeValue = deep && value is Map<String, dynamic>
          ? value.toSnakeCase(deep: true)
          : value;
      return MapEntry(snakeKey, snakeValue);
    });
  }
}
