import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/location.dart';

class Medicine {
  String? id;
  String? codeCis;
  Location? pharmacy;
  String? denomination;
  String? shape;
  String? image;
  String? brand;
  String? routeAdministration;

  Medicine({
    this.id,
    this.codeCis,
    this.pharmacy,
    this.denomination,
    this.shape,
    this.image,
    this.brand,
    this.routeAdministration,
  });

  factory Medicine.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> medicineData = doc.data() as Map<String, dynamic>;
    return Medicine(
      id: doc.id,
      codeCis: medicineData['Code CIS'],
      denomination: medicineData['Dénomination'],
      shape: medicineData['Forme'],
      routeAdministration: medicineData["Voies d'administration"],
      brand: medicineData['Marque'],
      image: medicineData['Image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Code CIS': codeCis,
      'Dénomination': denomination,
      'Forme': shape,
      'image': image,
      'brand': brand,
      'routeAdministration': routeAdministration,
    };
  }
}
