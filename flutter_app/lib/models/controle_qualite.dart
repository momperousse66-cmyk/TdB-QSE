import 'json_helpers.dart';

/// Registre "Contrôles qualité".
class ControleQualite {
  String id;
  String ville;
  String site;
  String type;
  String? controleur;
  DateTime? dateRealisee;
  double? note; // fraction 0..1

  ControleQualite({
    required this.id,
    required this.ville,
    required this.site,
    required this.type,
    this.controleur,
    this.dateRealisee,
    this.note,
  });

  factory ControleQualite.fromJson(Map<String, dynamic> j) => ControleQualite(
        id: j['id'] as String,
        ville: j['ville'] as String,
        site: j['site'] as String? ?? '',
        type: j['type'] as String? ?? '',
        controleur: j['controleur'] as String?,
        dateRealisee: parseDate(j['dateRealisee']),
        note: asDouble(j['note']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ville': ville,
        'site': site,
        'type': type,
        'controleur': controleur,
        'dateRealisee': dateToJson(dateRealisee),
        'note': note,
      };
}
