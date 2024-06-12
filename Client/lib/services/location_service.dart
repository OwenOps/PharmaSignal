import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/location.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';

class LocationService
    implements CrudFutureService<Location>, CrudStreamService<Location> {
  final CollectionReference _locationCollections =
      FirebaseFirestore.instance.collection('location');

  @override
  Future<String> createF(Location location) async {
    DocumentReference docRef = await _locationCollections.add(location.toMap());
    return docRef.id;
  }

  @override
  Future<Location?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _locationCollections.doc(id).get();
      if (docSnapshot.exists) {
        return Location.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des données de localisation: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllF() async {
    QuerySnapshot querySnapshot = await _locationCollections.get();
    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> updateF(Location location) async {
    if (location.id == null) {
      return;
    }

    await _locationCollections.doc(location.id).update(location.toMap());
  }

  @override
  Future<void> deleteF(String medicineId) async {
    await _locationCollections.doc(medicineId).delete();
  }

  @override
  Location getNew() {
    return Location(
      id: "0",
      postalCode: "",
      city: "",
      pharmacy: "",
    );
  }

  @override
  Stream<Location?> getByIdS(String id) {
    try {
      return _locationCollections.doc(id).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return Location.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération de la pharmacie : $e');
      rethrow;
    }
  }

  Stream<List<Location>> getAllWithFilterCpS(String? codePostal) {
    try {
      return _locationCollections
          .where('cp', isEqualTo: codePostal)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Location.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération de la localisation : $e');
      throw e;
    }
  }

  @override
  Stream<QuerySnapshot> getAllS() {
    try {
      return _locationCollections.snapshots();
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération de la pharmacie : $e');
      throw e;
    }
  }
}
