/// Réglages communs modifiables depuis l'écran "Options".
class Parametres {
  int preavisEcheanceJours;
  double? objectifQualite; // fraction 0..1
  double? objectifPdpComplet; // fraction 0..1
  int? delaiReponseRcJours;
  String themeMode;

  Parametres({
    this.preavisEcheanceJours = 30,
    this.objectifQualite,
    this.objectifPdpComplet,
    this.delaiReponseRcJours,
    this.themeMode = 'system',
  });

  factory Parametres.fromJson(Map<String, dynamic> j) => Parametres(
        preavisEcheanceJours: (j['preavisEcheanceJours'] as num?)?.toInt() ?? 30,
        objectifQualite: (j['objectifQualite'] as num?)?.toDouble(),
        objectifPdpComplet: (j['objectifPdpComplet'] as num?)?.toDouble(),
        delaiReponseRcJours: (j['delaiReponseRcJours'] as num?)?.toInt(),
        themeMode: const {'light', 'dark', 'system'}.contains(j['themeMode']) ? j['themeMode'] as String : 'system',
      );

  Map<String, dynamic> toJson() => {
        'preavisEcheanceJours': preavisEcheanceJours,
        'objectifQualite': objectifQualite,
        'objectifPdpComplet': objectifPdpComplet,
        'delaiReponseRcJours': delaiReponseRcJours,
        'themeMode': themeMode,
      };
}
