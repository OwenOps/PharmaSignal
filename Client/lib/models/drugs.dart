class MedicamentWithId extends Medicament {
  final String id;

  MedicamentWithId({
    required this.id,
    required String codeCIS,
    required String forme,
    required String image,
    required String marque,
    required String voiesAdministration,
    required String denomination,
  }) : super(
          codeCIS: codeCIS,
          forme: forme,
          image: image,
          marque: marque,
          voiesAdministration: voiesAdministration,
          denomination: denomination,
        );

  factory MedicamentWithId.fromMap(
      Map<String, dynamic> data, String documentId) {
    return MedicamentWithId(
      id: documentId,
      codeCIS: data['Code CIS'],
      forme: data['Forme'],
      image: data['Image'],
      marque: data['Marque'],
      voiesAdministration: data['Voies d\'administration'],
      denomination: data['Dénomination'],
    );
  }
}

class Medicament {
  final String codeCIS;
  final String forme;
  final String image;
  final String marque;
  final String voiesAdministration;
  final String denomination;

  Medicament({
    required this.codeCIS,
    required this.forme,
    required this.image,
    required this.marque,
    required this.voiesAdministration,
    required this.denomination,
  });

  factory Medicament.fromMap(Map<String, dynamic> data) {
    return Medicament(
      codeCIS: data['Code CIS'],
      forme: data['Forme'],
      image: data['Image'],
      marque: data['Marque'],
      voiesAdministration: data['Voies d\'administration'],
      denomination: data['Dénomination'],
    );
  }
}
