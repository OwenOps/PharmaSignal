import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String? id;
  int? codeCip;
  Timestamp? dateReport;
  String? denomination;
  String? shape;
  String? image;
  String? brand;
  String? idPharmacy;
  int? quantityAsked;
  String? statut;
  String? routeAdministration;

  Report({
    this.id,
    this.codeCip,
    this.dateReport,
    this.denomination,
    this.shape,
    this.image,
    this.brand,
    this.idPharmacy,
    this.quantityAsked,
    this.statut,
    this.routeAdministration,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    doc.data() as Map<String, dynamic>;
    return Report(
      id: doc.id,
      codeCip: doc['Code CIP'],
      dateReport: doc['DateSignalement'],
      denomination: doc['Dénomination'],
      shape: doc['Forme'],
      image: doc['Image'],
      brand: doc['Marque'],
      idPharmacy: doc['Pharmacie'],
      quantityAsked: doc['QuantiteVoulue'],
      statut: doc['Statut'],
      routeAdministration: doc["Voies d'administration"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Code CIP': codeCip,
      'DateSignalement': dateReport,
      'Dénomination': denomination,
      'Forme': shape,
      'Image': image,
      'Marque': brand,
      'Pharmacie': idPharmacy,
      'QuantiteVoulue': quantityAsked,
      'Statut': statut,
      "Voies d'administration": routeAdministration,
    };
  }
}
