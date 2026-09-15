import 'package:flutter/material.dart';

const _statusColors = {
  'Retard': Color(0xFFFCE4E4),
  'Expiré': Color(0xFFFCE4E4),
  'À compléter': Color(0xFFFCE4E4),
  'Incohérent': Color(0xFFFCE4E4),
  'Doublon': Color(0xFFFCE4E4),
  'Réception manquante': Color(0xFFFCE4E4),
  'Hors délai': Color(0xFFFCE4E4),
  'À renouveler': Color(0xFFFCE8C3),
  'En attente': Color(0xFFFCE8C3),
  'Réalisée': Color(0xFFE2F0E8),
  'À jour': Color(0xFFE2F0E8),
  'Dans le délai': Color(0xFFE2F0E8),
};

const _statusTextColors = {
  'Retard': Color(0xFF9C2525),
  'Expiré': Color(0xFF9C2525),
  'À compléter': Color(0xFF9C2525),
  'Incohérent': Color(0xFF9C2525),
  'Doublon': Color(0xFF9C2525),
  'Réception manquante': Color(0xFF9C2525),
  'Hors délai': Color(0xFF9C2525),
  'À renouveler': Color(0xFF875900),
  'En attente': Color(0xFF875900),
  'Réalisée': Color(0xFF1F6B4A),
  'À jour': Color(0xFF1F6B4A),
  'Dans le délai': Color(0xFF1F6B4A),
};

/// Reprend le code couleur "mise en forme conditionnelle" du classeur Excel
/// (rouge = à traiter, ambre = à surveiller, vert = conforme).
class StatusChip extends StatelessWidget {
  final String label;
  const StatusChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final bg = _statusColors[label] ?? const Color(0xFFEDF2F7);
    final fg = _statusTextColors[label] ?? const Color(0xFF243746);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
