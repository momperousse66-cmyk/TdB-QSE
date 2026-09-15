enum FieldType { text, multiline, number, percent, date, dropdown }

/// Décrit un champ éditable d'un registre : utilisé à la fois pour construire
/// la colonne du tableau et le champ du formulaire d'édition générique.
class FieldSpec {
  final String key;
  final String label;
  final FieldType type;
  final List<String>? options;
  final bool required;

  const FieldSpec({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.required = false,
  });
}
