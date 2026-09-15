import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/action_item.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'idAction', label: 'ID action', type: FieldType.text, required: true),
  FieldSpec(key: 'famille', label: 'Famille', type: FieldType.dropdown, options: ['Processus', 'Audit chantier']),
  FieldSpec(key: 'origine', label: 'Origine / site', type: FieldType.text),
  FieldSpec(key: 'ouverture', label: 'Ouverture', type: FieldType.date),
  FieldSpec(key: 'probleme', label: 'Problème', type: FieldType.multiline),
  FieldSpec(key: 'actionARealiser', label: 'Action à réaliser', type: FieldType.multiline, required: true),
  FieldSpec(key: 'responsable', label: 'Responsable', type: FieldType.text),
  FieldSpec(key: 'echeance', label: 'Échéance', type: FieldType.date),
  FieldSpec(key: 'realisation', label: 'Réalisation', type: FieldType.date),
  FieldSpec(key: 'evaluation', label: 'Évaluation', type: FieldType.dropdown, options: ['Non vérifiée', 'Efficace', 'A revoir']),
  FieldSpec(key: 'preuves', label: 'Preuves / observations', type: FieldType.multiline),
];

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.actions.where((a) => a.ville == state.villeSelectionnee).toList()
          ..sort((a, b) => a.idAction.compareTo(b.idAction));
        return GenericRegisterScreen<ActionItem>(
          title: 'Actions — ${state.villeSelectionnee}',
          subtitle: "Plans d'actions et audits chantier. Colonnes calculées : avancement et retard.",
          fields: _fields,
          items: items,
          idOf: (a) => a.id,
          toJson: (a) => a.toJson(),
          fromJson: ActionItem.fromJson,
          emptyRecord: () => ActionItem(
            id: state.newId('ac'),
            ville: state.villeSelectionnee,
            idAction: '',
            famille: 'Processus',
          ).toJson(),
          onSave: state.upsertAction,
          onDelete: state.deleteAction,
          extraColumns: [
            ExtraColumn('Avancement', (a) => a.avancement(state.dateSituation)),
            ExtraColumn('Retard (j)', (a) => a.retardJours(state.dateSituation).toString(), isStatus: false),
          ],
        );
      },
    );
  }
}
