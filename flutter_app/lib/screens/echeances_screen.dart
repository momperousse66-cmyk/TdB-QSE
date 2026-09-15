import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/echeance.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'famille', label: 'Famille', type: FieldType.dropdown, options: ['Habilitation', 'VPO', 'Exercice']),
  FieldSpec(key: 'site', label: 'Site', type: FieldType.text),
  FieldSpec(key: 'personne', label: 'Personne / vérificateur', type: FieldType.text),
  FieldSpec(key: 'objet', label: 'Objet', type: FieldType.text, required: true),
  FieldSpec(key: 'derniereRealisation', label: 'Dernière réalisation', type: FieldType.date),
  FieldSpec(key: 'prochaineEcheance', label: 'Prochaine échéance', type: FieldType.date),
  FieldSpec(key: 'commentaires', label: 'Commentaires', type: FieldType.multiline),
];

class EcheancesScreen extends StatelessWidget {
  const EcheancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.echeances.where((e) => e.ville == state.villeSelectionnee).toList()
          ..sort((a, b) =>
              (a.prochaineEcheance ?? DateTime(2100)).compareTo(b.prochaineEcheance ?? DateTime(2100)));
        return GenericRegisterScreen<Echeance>(
          title: 'Échéances — ${state.villeSelectionnee}',
          subtitle: 'Habilitations, VPO et exercices obligatoires.',
          fields: _fields,
          items: items,
          idOf: (e) => e.id,
          toJson: (e) => e.toJson(),
          fromJson: Echeance.fromJson,
          emptyRecord: () => Echeance(
            id: state.newId('ech'),
            ville: state.villeSelectionnee,
            famille: 'Habilitation',
          ).toJson(),
          onSave: state.upsertEcheance,
          onDelete: state.deleteEcheance,
          extraColumns: [
            ExtraColumn(
                'État', (e) => e.etat(state.dateSituation, state.parametres.preavisEcheanceJours)),
          ],
        );
      },
    );
  }
}
