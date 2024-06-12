import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String? id;
  String? postalCode;
  String? city;
  String? pharmacy;

  Location({
    this.id,
    this.postalCode,
    this.city,
    this.pharmacy,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> locationData = doc.data() as Map<String, dynamic>;
    return Location(
      id: doc.id,
      postalCode: locationData['cp'],
      city: locationData['intitule'],
      pharmacy: locationData['nom_pharma'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cp': postalCode,
      'intitule': city,
      'nom_pharma': pharmacy,
    };
  }
}
