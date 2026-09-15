/// Réglages communs modifiables depuis l'écran "Paramètres".
class Parametres {
  int preavisEcheanceJours;
  double? objectifQualite; // fraction 0..1
  double? objectifPdpComplet; // fraction 0..1
  int? delaiReponseRcJours;

  Parametres({
    this.preavisEcheanceJours = 30,
    this.objectifQualite,
    this.objectifPdpComplet,
    this.delaiReponseRcJours,
  });

  factory Parametres.fromJson(Map<String, dynamic> j) => Parametres(
        preavisEcheanceJours: (j['preavisEcheanceJours'] as num?)?.toInt() ?? 30,
        objectifQualite: (j['objectifQualite'] as num?)?.toDouble(),
        objectifPdpComplet: (j['objectifPdpComplet'] as num?)?.toDouble(),
        delaiReponseRcJours: (j['delaiReponseRcJours'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'preavisEcheanceJours': preavisEcheanceJours,
        'objectifQualite': objectifQualite,
        'objectifPdpComplet': objectifPdpComplet,
        'delaiReponseRcJours': delaiReponseRcJours,
      };
}
