DateTime? parseDate(dynamic v) {
  if (v == null) return null;
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}

String? dateToJson(DateTime? d) => d?.toIso8601String();

double? asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String && v.isNotEmpty) return double.tryParse(v);
  return null;
}

int? asInt(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toInt();
  if (v is String && v.isNotEmpty) return int.tryParse(v);
  return null;
}
