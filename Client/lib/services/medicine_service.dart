import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/medicine.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';

class MedicineService
    implements CrudFutureService<Medicine>, CrudStreamService<Medicine> {
  final CollectionReference _medicineCollections =
      FirebaseFirestore.instance.collection('medicament');

  @override
  Future<String> createF(Medicine medicine) async {
    DocumentReference docRef = await _medicineCollections.add(medicine.toMap());
    return docRef.id;
  }

  @override
  Future<Medicine?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _medicineCollections.doc(id).get();
      if (docSnapshot.exists) {
        return Medicine.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du médicament: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllF() async {
    QuerySnapshot querySnapshot = await _medicineCollections.get();
    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> updateF(Medicine medicine) async {
    if (medicine.id == null) {
      return;
    }

    await _medicineCollections.doc(medicine.id).update(medicine.toMap());
  }

  @override
  Future<void> deleteF(String medicineId) async {
    await _medicineCollections.doc(medicineId).delete();
  }

  @override
  Medicine getNew() {
    return Medicine(
      codeCis: "",
      denomination: "",
      shape: "",
      routeAdministration: "",
      brand: "",
      image: "",
    );
  }

  @override
  Stream<Medicine?> getByIdS(String id) {
    try {
      return _medicineCollections.doc(id).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return Medicine.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      });
    } catch (e) {
      print('Une erreur est survenue lors de la récupération du médicament $e');
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot> getAllS() {
    try {
      return _medicineCollections.snapshots();
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération des medicaments: $e');
      throw e;
    }
  }
}
