import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Persiste l'intégralité des données de l'application dans un unique
/// fichier JSON local (répertoire documents de l'application). Simple à
/// sauvegarder, dupliquer ou transférer d'un appareil à l'autre.
class StorageService {
  static const _fileName = 'qse_dashboard_data.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<Map<String, dynamic>?> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return null;
      final content = await f.readAsString();
      if (content.trim().isEmpty) return null;
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    final f = await _file();
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }
}
