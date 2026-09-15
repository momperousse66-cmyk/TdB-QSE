import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/kpi_card.dart';

final _dateFmt = DateFormat('dd/MM/yyyy');
const _navy = Color(0xFF243B53);
const _moisLongs = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
];
String _formatMois(DateTime d) => '${_moisLongs[d.month - 1]} ${d.year}';

/// Reproduit l'onglet "Tableau de bord" du classeur Excel : activité du mois,
/// registres à la date de situation, et deux graphiques. Se recalcule
/// immédiatement quand un registre est modifié (Provider notifie l'écran).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _pct(double? v) => v == null ? 'n.d.' : '${(v * 100).toStringAsFixed(1)}%';
  String _num(num? v) => v == null ? 'n.d.' : (v == v.roundToDouble() ? v.toInt().toString() : v.toString());

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ville = state.villeSelectionnee;
    final mois = state.moisSelectionne;
    final asOf = state.dateSituation;

    final sm = state.suiviMensuel
        .where((s) => s.ville == ville && s.mois.year == mois.year && s.mois.month == mois.month)
        .toList();
    final smEntry = sm.isEmpty ? null : sm.first;
    final smDoublon = sm.length > 1;

    final controlesMois = state.controlesQualite.where((c) =>
        c.ville == ville &&
        c.dateRealisee != null &&
        c.dateRealisee!.year == mois.year &&
        c.dateRealisee!.month == mois.month);
    final notes = controlesMois.map((c) => c.note).whereType<double>().toList();
    final indiceQualite = notes.isEmpty ? null : notes.reduce((a, b) => a + b) / notes.length;

    final reclamationsMois = state.reclamations.where((r) =>
        r.ville == ville &&
        r.categorie == 'Réclamation' &&
        r.reception != null &&
        r.reception!.year == mois.year &&
        r.reception!.month == mois.month);

    final actionsVille = state.actions.where((a) => a.ville == ville).toList();
    final actionsParEtat = <String, int>{};
    for (final a in actionsVille) {
      final e = a.avancement(asOf);
      actionsParEtat[e] = (actionsParEtat[e] ?? 0) + 1;
    }

    final pdpVille = state.plansPrevention.where((p) => p.ville == ville).toList();
    final pdpComplets = pdpVille.where((p) => p.pdpComplet(asOf)).length;
    final pdpExpires = pdpVille.where((p) => p.etatEcheance(asOf, state.parametres.preavisEcheanceJours) == 'Expiré').length;
    final pdpIncomplets = pdpVille.where((p) => p.etatEcheance(asOf, state.parametres.preavisEcheanceJours) == 'À compléter').length;

    final echVille = state.echeances.where((e) => e.ville == ville).toList();
    final echExpirees = echVille.where((e) => e.etat(asOf, state.parametres.preavisEcheanceJours) == 'Expiré').length;
    final echARenouveler = echVille.where((e) => e.etat(asOf, state.parametres.preavisEcheanceJours) == 'À renouveler').length;
    final echManquantes = echVille.where((e) => e.etat(asOf, state.parametres.preavisEcheanceJours) == 'À compléter').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord QSE')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Selecteurs(context: context, state: state),
          const SizedBox(height: 20),
          if (state.villes.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('Ajoutez une ville dans Paramètres pour commencer.'),
            ),
          Text('Activité du mois — ${_formatMois(mois)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _navy)),
          const SizedBox(height: 10),
          Wrap(spacing: 12, runSpacing: 12, children: [
            KpiCard(label: 'Contrôles qualité enregistrés', value: _num(controlesMois.length)),
            KpiCard(
              label: 'Indice qualité (moyenne des notes)',
              value: _pct(indiceQualite),
              sousTitre: state.parametres.objectifQualite != null
                  ? 'Objectif ${_pct(state.parametres.objectifQualite)}'
                  : 'Cible à définir',
              accent: indiceQualite != null &&
                      state.parametres.objectifQualite != null &&
                      indiceQualite < state.parametres.objectifQualite!
                  ? Colors.red.shade700
                  : null,
            ),
            KpiCard(label: 'Réclamations reçues', value: _num(reclamationsMois.length)),
            KpiCard(label: 'Produits écolabellisés', value: _pct(smEntry?.tauxEcolabel)),
            KpiCard(label: 'Papier (feuilles)', value: _num(smEntry?.papierFeuilles)),
            KpiCard(label: 'Électricité (kWh)', value: _num(smEntry?.electriciteKwh)),
            KpiCard(label: 'Émissions CO2 (kg)', value: _num(smEntry?.co2Kg)),
            KpiCard(label: 'Distance parcourue (km)', value: _num(smEntry?.distanceKm)),
            KpiCard(label: 'AT avec arrêt', value: _num(smEntry?.atAvecArret)),
            KpiCard(label: 'Audits réalisés', value: _num(smEntry?.auditsRealises)),
            KpiCard(label: 'Satisfaction client', value: _pct(smEntry?.satisfaction)),
          ]),
          if (smDoublon)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Doublon détecté : plusieurs lignes Suivi mensuel pour ce mois.',
                  style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 28),
          const Text('Registres à la date de situation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _navy)),
          Text('Situation au ${_dateFmt.format(asOf)}', style: const TextStyle(color: Color(0xFF637588))),
          const SizedBox(height: 10),
          Wrap(spacing: 12, runSpacing: 12, children: [
            KpiCard(
              label: 'Actions réalisées',
              value: actionsVille.isEmpty ? 'n.d.' : _pct((actionsParEtat['Réalisée'] ?? 0) / actionsVille.length),
            ),
            KpiCard(label: 'Actions en retard', value: _num(actionsParEtat['Retard'] ?? 0)),
            KpiCard(label: 'Actions sans échéance exploitable', value: _num(actionsParEtat['À compléter'] ?? 0)),
            KpiCard(
              label: 'PdP complets et valides',
              value: pdpVille.isEmpty ? 'n.d.' : _pct(pdpComplets / pdpVille.length),
              sousTitre: state.parametres.objectifPdpComplet != null
                  ? 'Objectif ${_pct(state.parametres.objectifPdpComplet)}'
                  : 'Cible à définir',
            ),
            KpiCard(label: 'PdP expirés', value: _num(pdpExpires)),
            KpiCard(label: 'PdP sans échéance', value: _num(pdpIncomplets)),
            KpiCard(label: 'Habilitations / VPO / exercices expirés', value: _num(echExpirees)),
            KpiCard(label: 'Échéances dans le préavis', value: _num(echARenouveler)),
            KpiCard(label: 'Échéances manquantes', value: _num(echManquantes)),
          ]),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _QualiteChart(state: state, ville: ville, annee: mois.year)),
              const SizedBox(width: 16),
              Expanded(child: _ActionsChart(actionsParEtat: actionsParEtat)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'n.d. : aucune mesure exploitable. Un registre vide ne prouve pas une absence d\'événements.',
            style: TextStyle(color: Color(0xFF637588), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Selecteurs extends StatelessWidget {
  final BuildContext context;
  final AppState state;
  const _Selecteurs({required this.context, required this.state});

  @override
  Widget build(BuildContext _) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (state.villes.isNotEmpty)
          DropdownButton<String>(
            value: state.villes.any((v) => v.nom == state.villeSelectionnee)
                ? state.villeSelectionnee
                : state.villes.first.nom,
            items: state.villes.map((v) => DropdownMenuItem(value: v.nom, child: Text(v.nom))).toList(),
            onChanged: (v) {
              if (v != null) state.setVilleSelectionnee(v);
            },
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_month, size: 18),
          label: Text('Mois : ${_formatMois(state.moisSelectionne)}'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.moisSelectionne,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              helpText: 'Mois des indicateurs',
            );
            if (picked != null) state.setMoisSelectionne(picked);
          },
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.event_available, size: 18),
          label: Text('Situation au : ${_dateFmt.format(state.dateSituation)}'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.dateSituation,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              helpText: 'Date de situation',
            );
            if (picked != null) state.setDateSituation(picked);
          },
        ),
      ],
    );
  }
}

class _QualiteChart extends StatelessWidget {
  final AppState state;
  final String ville;
  final int annee;
  const _QualiteChart({required this.state, required this.ville, required this.annee});

  @override
  Widget build(BuildContext context) {
    final values = List<double?>.filled(12, null);
    for (var m = 0; m < 12; m++) {
      final notes = state.controlesQualite
          .where((c) =>
              c.ville == ville &&
              c.dateRealisee != null &&
              c.dateRealisee!.year == annee &&
              c.dateRealisee!.month == m + 1)
          .map((c) => c.note)
          .whereType<double>()
          .toList();
      if (notes.isNotEmpty) values[m] = notes.reduce((a, b) => a + b) / notes.length;
    }
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Indice qualité mensuel (%)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(BarChartData(
              maxY: 1,
              barGroups: [
                for (var i = 0; i < 12; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: values[i] ?? 0, color: _navy, width: 10),
                  ]),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text('${(v * 100).toInt()}%', style: const TextStyle(fontSize: 9)))),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                            ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'][v.toInt() % 12],
                            style: const TextStyle(fontSize: 9)))),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
            )),
          ),
        ],
      ),
    );
  }
}

class _ActionsChart extends StatelessWidget {
  final Map<String, int> actionsParEtat;
  const _ActionsChart({required this.actionsParEtat});

  @override
  Widget build(BuildContext context) {
    const labels = ['Réalisée', 'Retard', 'À venir', 'À compléter'];
    final maxY = (actionsParEtat.values.isEmpty ? 1 : actionsParEtat.values.reduce((a, b) => a > b ? a : b))
        .toDouble()
        .clamp(1.0, double.infinity);
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Avancement des actions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(BarChartData(
              maxY: maxY,
              barGroups: [
                for (var i = 0; i < labels.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                        toY: (actionsParEtat[labels[i]] ?? 0).toDouble(), color: _navy, width: 22),
                  ]),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) =>
                            Text(labels[v.toInt() % labels.length], style: const TextStyle(fontSize: 9)))),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
            )),
          ),
        ],
      ),
    );
  }
}
