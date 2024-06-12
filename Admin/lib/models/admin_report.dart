import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReport {
  String? id;
  String? codeCip;
  Timestamp? dateReport;
  Timestamp? dateProcessing;
  String? denomination;
  String? shape;
  String? idSignalement;
  String? image;
  String? brand;
  String? idPharmacy;
  int? quantityGot;
  int? quantityAsked;
  String? statut;
  String? idUser;
  String? routeAdministration;

  AdminReport({
    this.id,
    this.codeCip,
    this.dateReport,
    this.dateProcessing,
    this.denomination,
    this.shape,
    this.idSignalement,
    this.image,
    this.brand,
    this.idPharmacy,
    this.quantityAsked,
    this.quantityGot,
    this.statut,
    this.idUser,
    this.routeAdministration,
  });

  factory AdminReport.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> reportData = doc.data() as Map<String, dynamic>;
    return AdminReport(
      id: doc.id,
      codeCip: reportData['CodeCIP'],
      dateReport: reportData['DateSignalement'],
      dateProcessing: reportData['DateTraitement'],
      denomination: reportData['Dénomination'],
      shape: reportData['Forme'],
      idSignalement: reportData['IdSignalement'],
      image: reportData['Image'],
      brand: reportData['Marque'],
      idPharmacy: reportData["Pharmacie"],
      quantityGot: reportData['QuantiteRecue'],
      quantityAsked: reportData['QuantiteVoulue'],
      statut: reportData['Statut'],
      idUser: reportData['UID_User'],
      routeAdministration: reportData["Voies d'administration"],
    );
  }

  Map<String, dynamic> toMap(String docId) {
    return {
      'CodeCIP': codeCip,
      'DateSignalement': dateReport,
      'DateTraitement': dateProcessing,
      'Dénomination': denomination,
      'Forme': shape,
      'IdSignalement': docId,
      'Image': image,
      'Marque': brand,
      'Pharmacie': idPharmacy,
      'QuantiteRecue': quantityGot,
      'QuantiteVoulue': quantityAsked,
      'Statut': statut,
      'UID_User': idUser,
      "Voies d'administration": routeAdministration,
    };
  }
}
