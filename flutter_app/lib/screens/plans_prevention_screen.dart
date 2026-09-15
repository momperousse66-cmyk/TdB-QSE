import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plan_prevention.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'otp', label: 'OTP', type: FieldType.text, required: true),
  FieldSpec(key: 'clientSite', label: 'Client / site', type: FieldType.text, required: true),
  FieldSpec(key: 'responsable', label: 'Responsable', type: FieldType.text),
  FieldSpec(key: 'echeanceSource', label: 'Échéance', type: FieldType.date),
  FieldSpec(key: 'analyseFaite', label: 'Analyse faite', type: FieldType.dropdown, options: ['Oui', 'Non', 'NC']),
  FieldSpec(key: 'analyseEnvoyee', label: 'Analyse envoyée', type: FieldType.dropdown, options: ['Oui', 'Non', 'NC']),
  FieldSpec(key: 'signeIsor', label: 'Signé ISOR', type: FieldType.dropdown, options: ['Oui', 'Non', 'NC']),
  FieldSpec(key: 'signeClient', label: 'Signé client', type: FieldType.dropdown, options: ['Oui', 'Non', 'NC']),
  FieldSpec(key: 'commenteAgents', label: 'Commenté agents', type: FieldType.dropdown, options: ['Oui', 'Non', 'NC']),
  FieldSpec(key: 'commentaires', label: 'Commentaires', type: FieldType.multiline),
];

class PlansPreventionScreen extends StatelessWidget {
  const PlansPreventionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items =
            state.plansPrevention.where((p) => p.ville == state.villeSelectionnee).toList()
              ..sort((a, b) => a.otp.compareTo(b.otp));
        return GenericRegisterScreen<PlanPrevention>(
          title: 'Plans de prévention — ${state.villeSelectionnee}',
          subtitle: 'PdP complet = échéance future + 5 validations "Oui".',
          fields: _fields,
          items: items,
          idOf: (p) => p.id,
          toJson: (p) => p.toJson(),
          fromJson: PlanPrevention.fromJson,
          emptyRecord: () => PlanPrevention(
            id: state.newId('pdp'),
            ville: state.villeSelectionnee,
            otp: '',
            clientSite: '',
          ).toJson(),
          onSave: state.upsertPlanPrevention,
          onDelete: state.deletePlanPrevention,
          extraColumns: [
            ExtraColumn('État échéance',
                (p) => p.etatEcheance(state.dateSituation, state.parametres.preavisEcheanceJours)),
            ExtraColumn('PdP complet', (p) => p.pdpComplet(state.dateSituation) ? 'Réalisée' : 'À compléter'),
          ],
        );
      },
    );
  }
}
