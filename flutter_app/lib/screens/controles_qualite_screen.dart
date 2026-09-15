import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/controle_qualite.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'site', label: 'Site', type: FieldType.text, required: true),
  FieldSpec(key: 'type', label: 'Type', type: FieldType.text),
  FieldSpec(key: 'controleur', label: 'Contrôleur', type: FieldType.text),
  FieldSpec(key: 'dateRealisee', label: 'Date réalisée', type: FieldType.date),
  FieldSpec(key: 'note', label: 'Note', type: FieldType.percent, required: true),
];

class ControlesQualiteScreen extends StatelessWidget {
  const ControlesQualiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items =
            state.controlesQualite.where((c) => c.ville == state.villeSelectionnee).toList()
              ..sort((a, b) => (a.dateRealisee ?? DateTime(1970)).compareTo(b.dateRealisee ?? DateTime(1970)));
        return GenericRegisterScreen<ControleQualite>(
          title: 'Contrôles qualité — ${state.villeSelectionnee}',
          subtitle: 'Note en pourcentage (0 à 100 %).',
          fields: _fields,
          items: items,
          idOf: (c) => c.id,
          toJson: (c) => c.toJson(),
          fromJson: ControleQualite.fromJson,
          emptyRecord: () => ControleQualite(
            id: state.newId('cq'),
            ville: state.villeSelectionnee,
            site: '',
            type: '',
          ).toJson(),
          onSave: state.upsertControleQualite,
          onDelete: state.deleteControleQualite,
        );
      },
    );
  }
}
