/// Une ville pilotée dans le tableau de bord. Ajouter une ville "réplique" le
/// modèle QSE (mêmes registres, mêmes calculs) pour un nouveau périmètre.
class Ville {
  String id;
  String nom;

  Ville({required this.id, required this.nom});

  factory Ville.fromJson(Map<String, dynamic> j) =>
      Ville(id: j['id'] as String, nom: j['nom'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'nom': nom};
}
