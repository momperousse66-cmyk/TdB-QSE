import 'package:flutter/material.dart';

/// Carte KPI reprenant la mise en page "Résultat / Objectif / Lecture" du
/// tableau de bord Excel.
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sousTitre;
  final Color? accent;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.sousTitre,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF637588), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: accent ?? const Color(0xFF243B53))),
          if (sousTitre != null) ...[
            const SizedBox(height: 4),
            Text(sousTitre!, style: const TextStyle(fontSize: 11, color: Color(0xFF637588))),
          ],
        ],
      ),
    );
  }
}
