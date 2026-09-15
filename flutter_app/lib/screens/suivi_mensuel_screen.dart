import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/suivi_mensuel.dart';
import '../state/app_state.dart';
import '../widgets/field_spec.dart';
import '../widgets/generic_register_screen.dart';

const _fields = [
  FieldSpec(key: 'mois', label: 'Mois', type: FieldType.date, required: true),
  FieldSpec(key: 'tauxEcolabel', label: 'Produits écolabellisés', type: FieldType.percent),
  FieldSpec(key: 'papierFeuilles', label: 'Papier (feuilles)', type: FieldType.number),
  FieldSpec(key: 'electriciteKwh', label: 'Électricité (kWh)', type: FieldType.number),
  FieldSpec(key: 'co2Kg', label: 'CO2 (kg)', type: FieldType.number),
  FieldSpec(key: 'distanceKm', label: 'Distance (km)', type: FieldType.number),
  FieldSpec(key: 'atAvecArret', label: 'AT avec arrêt', type: FieldType.number),
  FieldSpec(key: 'atAnalyses', label: 'AT analysés', type: FieldType.number),
  FieldSpec(key: 'auditsPrevus', label: 'Audits prévus', type: FieldType.number),
  FieldSpec(key: 'auditsRealises', label: 'Audits réalisés', type: FieldType.number),
  FieldSpec(key: 'satisfaction', label: 'Satisfaction', type: FieldType.percent),
  FieldSpec(key: 'avisSuivis', label: 'Avis suivis (stock)', type: FieldType.number),
  FieldSpec(key: 'avisClotures', label: 'Avis clôturés (stock)', type: FieldType.number),
  FieldSpec(key: 'commentaires', label: 'Commentaires / source', type: FieldType.multiline),
];

class SuiviMensuelScreen extends StatelessWidget {
  const SuiviMensuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.suiviMensuel.where((s) => s.ville == state.villeSelectionnee).toList()
          ..sort((a, b) => a.mois.compareTo(b.mois));
        return GenericRegisterScreen<SuiviMensuel>(
          title: 'Suivi mensuel — ${state.villeSelectionnee}',
          subtitle: 'Une seule ligne par ville et par mois. Laisser vide si la mesure manque (n.d.).',
          fields: _fields,
          items: items,
          idOf: (s) => s.id,
          toJson: (s) => s.toJson(),
          fromJson: SuiviMensuel.fromJson,
          emptyRecord: () => SuiviMensuel(
            id: state.newId('sm'),
            ville: state.villeSelectionnee,
            mois: state.moisSelectionne,
          ).toJson(),
          onSave: state.upsertSuiviMensuel,
          onDelete: state.deleteSuiviMensuel,
        );
      },
    );
  }
}
