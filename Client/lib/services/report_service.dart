import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/report.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';
class ReportService
    implements CrudFutureService<Report>, CrudStreamService<Report> {
  final CollectionReference _reportCollections =
      FirebaseFirestore.instance.collection('admin_signalement');

  @override
  Future<String> createF(Report report) async {
    DocumentReference docRef = _reportCollections.doc();
    String docId = docRef.id;

    await docRef.set(report.toMap());
    return docId;
  }

  @override
  Future<Report?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _reportCollections.doc(id).get();
      if (docSnapshot.exists) {
        return Report.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des signalements: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllF() async {
    QuerySnapshot querySnapshot = await _reportCollections.get();
    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> updateF(Report report) async {
    if (report.id == null) {
      return;
    }

    await _reportCollections.doc(report.id).update(report.toMap());
  }

  @override
  Future<void> deleteF(String reportId) async {
    await _reportCollections.doc(reportId).delete();
  }

  @override
  Report getNew() {
    return Report(
      id: "",
      codeCip: null,
      dateReport: null,
      denomination: "",
      shape: "",
      image: "",
      brand: "",
      idPharmacy: null,
      quantityAsked: 0,
      statut: null,
      routeAdministration: "",
    );
  }

  @override
  Stream<Report?> getByIdS(String id) {
    try {
      return _reportCollections.doc(id).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return Report.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération des signalements $e');
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot> getAllS() {
    try {
      return _reportCollections.snapshots();
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération des signalements: $e');
      rethrow;
    }
  }
}
