import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'field_spec.dart';

final _dateFmt = DateFormat('dd/MM/yyyy');

/// Boîte de dialogue générique : construit un formulaire à partir d'une liste
/// de [FieldSpec] et d'une map JSON initiale. Retourne la map modifiée, ou
/// `null` si l'utilisateur annule. Un seul formulaire sert pour les 6
/// registres, ce qui garde le code réplicable pour de futurs champs/registres.
Future<Map<String, dynamic>?> showRecordFormDialog({
  required BuildContext context,
  required String title,
  required List<FieldSpec> fields,
  required Map<String, dynamic> initial,
}) {
  final values = Map<String, dynamic>.from(initial);
  final controllers = <String, TextEditingController>{};
  for (final f in fields) {
    if (f.type != FieldType.dropdown) {
      final v = values[f.key];
      String text = '';
      if (v != null) {
        if (f.type == FieldType.percent && v is num) {
          text = (v * 100).toStringAsFixed(2);
        } else if (f.type == FieldType.date && v is String) {
          final d = DateTime.tryParse(v);
          text = d != null ? _dateFmt.format(d) : v;
        } else {
          text = v.toString();
        }
      }
      controllers[f.key] = TextEditingController(text: text);
    }
  }

  return showDialog<Map<String, dynamic>?>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fields.map((f) {
                switch (f.type) {
                  case FieldType.dropdown:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: f.label),
                        initialValue: (values[f.key] as String?) ??
                            (f.options?.isNotEmpty == true ? f.options!.first : null),
                        items: f.options!
                            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                            .toList(),
                        onChanged: (v) => setState(() => values[f.key] = v),
                      ),
                    );
                  case FieldType.date:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: controllers[f.key],
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: f.label,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final current = DateTime.tryParse(values[f.key]?.toString() ?? '') ??
                              DateTime.now();
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: current,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              values[f.key] = picked.toIso8601String();
                              controllers[f.key]!.text = _dateFmt.format(picked);
                            });
                          }
                        },
                      ),
                    );
                  case FieldType.percent:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: controllers[f.key],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: '${f.label} (%)'),
                        onChanged: (v) {
                          final n = double.tryParse(v.replaceAll(',', '.'));
                          values[f.key] = n == null ? null : n / 100;
                        },
                      ),
                    );
                  case FieldType.number:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: controllers[f.key],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: f.label),
                        onChanged: (v) => values[f.key] = double.tryParse(v.replaceAll(',', '.')),
                      ),
                    );
                  case FieldType.multiline:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: controllers[f.key],
                        maxLines: 3,
                        decoration: InputDecoration(labelText: f.label),
                        onChanged: (v) => values[f.key] = v,
                      ),
                    );
                  case FieldType.text:
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: controllers[f.key],
                        decoration: InputDecoration(labelText: f.label),
                        onChanged: (v) => values[f.key] = v,
                      ),
                    );
                }
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              for (final f in fields) {
                if (f.required && (values[f.key] == null || values[f.key].toString().trim().isEmpty)) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('${f.label} est obligatoire')),
                  );
                  return;
                }
              }
              Navigator.pop(ctx, values);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    ),
  );
}
