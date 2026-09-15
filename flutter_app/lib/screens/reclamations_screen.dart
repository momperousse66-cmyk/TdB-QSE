import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reclamation.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'client', label: 'Client', type: FieldType.text),
  FieldSpec(key: 'categorie', label: 'Catégorie', type: FieldType.dropdown, options: ['Réclamation', 'Avis', 'Autre']),
  FieldSpec(key: 'canal', label: 'Canal', type: FieldType.text),
  FieldSpec(key: 'emission', label: 'Émission', type: FieldType.date),
  FieldSpec(key: 'reception', label: 'Réception', type: FieldType.date),
  FieldSpec(key: 'reponse', label: 'Réponse', type: FieldType.date),
  FieldSpec(key: 'responsable', label: 'Responsable', type: FieldType.text),
  FieldSpec(key: 'motif', label: 'Motif / détail', type: FieldType.multiline),
  FieldSpec(key: 'actionMenee', label: 'Action menée', type: FieldType.multiline),
];

class ReclamationsScreen extends StatelessWidget {
  const ReclamationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.reclamations.where((r) => r.ville == state.villeSelectionnee).toList()
          ..sort((a, b) => (a.reception ?? DateTime(1970)).compareTo(b.reception ?? DateTime(1970)));
        return GenericRegisterScreen<Reclamation>(
          title: 'Réclamations — ${state.villeSelectionnee}',
          subtitle: 'Délai de réponse calculé en jours calendaires.',
          fields: _fields,
          items: items,
          idOf: (r) => r.id,
          toJson: (r) => r.toJson(),
          fromJson: Reclamation.fromJson,
          emptyRecord: () => Reclamation(
            id: state.newId('rc'),
            ville: state.villeSelectionnee,
          ).toJson(),
          onSave: state.upsertReclamation,
          onDelete: state.deleteReclamation,
          extraColumns: [
            ExtraColumn(
                'État réponse',
                (r) => r.etatReponse(state.dateSituation, state.parametres.delaiReponseRcJours)),
            ExtraColumn('Délai (j)', (r) => r.delaiJours()?.toString() ?? '', isStatus: false),
          ],
        );
      },
    );
  }
}
