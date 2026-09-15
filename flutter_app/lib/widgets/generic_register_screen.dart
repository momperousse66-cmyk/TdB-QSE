import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/excel_import_service.dart';
import 'field_spec.dart';
import 'record_form_dialog.dart';
import 'status_chip.dart';

final _dateFmt = DateFormat('dd/MM/yyyy');

/// Colonne calculée (statut, jours restants...) affichée en plus des champs
/// éditables, à partir des règles métier définies sur le modèle.
class ExtraColumn<T> {
  final String label;
  final String Function(T) compute;
  final bool isStatus;
  const ExtraColumn(this.label, this.compute, {this.isStatus = true});
}

/// Écran générique "registre" : tableau + formulaire d'ajout/édition/suppression.
/// Un seul widget sert pour les 6 registres du classeur (Actions, Plans de
/// prévention, Contrôles qualité, Échéances, Réclamations, Suivi mensuel) :
/// ajouter un futur registre ne demande qu'un schéma de champs, pas un nouvel
/// écran.
class GenericRegisterScreen<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FieldSpec> fields;
  final List<T> items;
  final Map<String, dynamic> Function(T) toJson;
  final T Function(Map<String, dynamic>) fromJson;
  final Future<void> Function(T) onSave;
  final Future<void> Function(String id) onDelete;
  final String Function(T) idOf;
  final List<ExtraColumn<T>> extraColumns;
  final Map<String, dynamic> Function() emptyRecord;

  const GenericRegisterScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.items,
    required this.toJson,
    required this.fromJson,
    required this.onSave,
    required this.onDelete,
    required this.idOf,
    required this.emptyRecord,
    this.extraColumns = const [],
  });

  String _display(dynamic v, FieldSpec f) {
    if (v == null || v.toString().isEmpty) return '';
    if (f.type == FieldType.percent && v is num) return '${(v * 100).toStringAsFixed(1)}%';
    if (f.type == FieldType.date) {
      final d = v is DateTime ? v : DateTime.tryParse(v.toString());
      return d != null ? _dateFmt.format(d) : v.toString();
    }
    if (v is num) {
      return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    }
    return v.toString();
  }

  Future<void> _editRecord(BuildContext context, T? existing) async {
    final initial = existing != null ? toJson(existing) : emptyRecord();
    final result = await showRecordFormDialog(
      context: context,
      title: existing == null ? 'Ajouter — $title' : 'Modifier — $title',
      fields: fields,
      initial: initial,
    );
    if (result != null) {
      await onSave(fromJson(result));
    }
  }

  Future<void> _importFromExcel(BuildContext context) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xlsm'],
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();

    final outcome = parseExcelForFields(bytes, fields);
    for (final row in outcome.rows) {
      final merged = {...emptyRecord(), ...row};
      await onSave(fromJson(merged));
    }

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Excel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${outcome.rows.length} ligne(s) ajoutee(s) depuis "${file.name}".'),
            if (outcome.unmatchedFields.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Colonnes non trouvees dans le fichier (laissees vides) : ${outcome.unmatchedFields.join(', ')}'),
            ],
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Importer un tableau Excel (.xlsx/.xlsm)',
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () => _importFromExcel(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editRecord(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une ligne'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(subtitle, style: const TextStyle(color: Color(0xFF637588))),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                final tableFields = compact ? fields.take(3).toList() : fields;
                return items.isEmpty
                    ? const Center(
                        child: Text('Aucune donnée pour cette ville. Utilisez "Ajouter une ligne".'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFF243B53)),
                            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            columns: [
                              ...tableFields.map((f) => DataColumn(label: Text(f.label))),
                              ...extraColumns.map((c) => DataColumn(label: Text(c.label))),
                              const DataColumn(label: Text('')),
                            ],
                            rows: items.map((item) {
                              final json = toJson(item);
                              return DataRow(cells: [
                                ...tableFields.map((f) => DataCell(Text(_display(json[f.key], f)))),
                                ...extraColumns.map((c) => DataCell(
                                    c.isStatus ? StatusChip(c.compute(item)) : Text(c.compute(item)))),
                                DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _editRecord(context, item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18),
                                    onPressed: () => onDelete(idOf(item)),
                                  ),
                                ])),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
