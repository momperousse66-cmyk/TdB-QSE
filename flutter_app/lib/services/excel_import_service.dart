import 'package:excel/excel.dart' as xls;

import '../widgets/field_spec.dart';

const _accents = 'àáâãäåèéêëìíîïòóôõöùúûüçñÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÇÑ';
const _plain = 'aaaaaaeeeeiiiiooooouuuucnAAAAAAEEEEIIIIOOOOOUUUUCN';

String _normalize(String s) {
  var out = s.trim();
  for (var i = 0; i < _accents.length; i++) {
    out = out.replaceAll(_accents[i], _plain[i]);
  }
  return out.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

/// Résultat d'un import : les lignes prêtes à enregistrer, et les champs du
/// registre qui n'ont trouvé aucune colonne correspondante dans le fichier.
class ExcelImportOutcome {
  final List<Map<String, dynamic>> rows;
  final List<String> unmatchedFields;
  ExcelImportOutcome(this.rows, this.unmatchedFields);
}

/// Lit un classeur Excel (.xlsx/.xlsm) et associe automatiquement les
/// colonnes de la ligne d'en-tête aux champs du registre par nom (label ou
/// clé, insensible aux accents/majuscules), pour ajouter les lignes sans
/// mise en correspondance manuelle.
ExcelImportOutcome parseExcelForFields(List<int> bytes, List<FieldSpec> fields, {String? sheetName}) {
  final book = xls.Excel.decodeBytes(bytes);
  if (book.tables.isEmpty) return ExcelImportOutcome([], fields.map((f) => f.label).toList());
  final name = sheetName ?? book.tables.keys.first;
  final sheet = book.tables[name];
  if (sheet == null || sheet.rows.isEmpty) {
    return ExcelImportOutcome([], fields.map((f) => f.label).toList());
  }

  final header = sheet.rows.first;
  final columnForField = <String, int>{};
  for (final f in fields) {
    for (var c = 0; c < header.length; c++) {
      final text = header[c]?.value?.toString() ?? '';
      if (text.isEmpty) continue;
      if (_normalize(text) == _normalize(f.label) || _normalize(text) == _normalize(f.key)) {
        columnForField[f.key] = c;
        break;
      }
    }
  }

  final rows = <Map<String, dynamic>>[];
  for (var r = 1; r < sheet.rows.length; r++) {
    final row = sheet.rows[r];
    final hasData = row.any((c) => c?.value != null && c!.value.toString().trim().isNotEmpty);
    if (!hasData) continue;
    final map = <String, dynamic>{};
    for (final f in fields) {
      final col = columnForField[f.key];
      if (col == null || col >= row.length) continue;
      map[f.key] = _convertCell(row[col]?.value, f);
    }
    rows.add(map);
  }

  final unmatched = [for (final f in fields) if (!columnForField.containsKey(f.key)) f.label];
  return ExcelImportOutcome(rows, unmatched);
}

dynamic _convertCell(xls.CellValue? value, FieldSpec f) {
  if (value == null) return null;
  switch (f.type) {
    case FieldType.date:
      if (value is xls.DateTimeCellValue) {
        return DateTime(value.year, value.month, value.day, value.hour, value.minute, value.second)
            .toIso8601String();
      }
      if (value is xls.DateCellValue) {
        return DateTime(value.year, value.month, value.day).toIso8601String();
      }
      return DateTime.tryParse(value.toString())?.toIso8601String();
    case FieldType.number:
    case FieldType.percent:
      double? n;
      if (value is xls.DoubleCellValue) {
        n = value.value;
      } else if (value is xls.IntCellValue) {
        n = value.value.toDouble();
      } else {
        n = double.tryParse(value.toString().replaceAll('%', '').replaceAll(',', '.').trim());
      }
      if (n == null) return null;
      // Une valeur > 1 saisie dans une colonne "pourcentage" est traitée comme des points (45 -> 45 %).
      if (f.type == FieldType.percent && n.abs() > 1) n = n / 100;
      return n;
    case FieldType.dropdown:
    case FieldType.text:
    case FieldType.multiline:
      return value is xls.TextCellValue ? value.value.toString() : value.toString();
  }
}
