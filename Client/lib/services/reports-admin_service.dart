import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/admin_report.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';

class AdminReportService
    implements CrudFutureService<AdminReport>, CrudStreamService<AdminReport> {
  final CollectionReference _reportCollections = FirebaseFirestore.instance.collection('admin_signalement');

  @override
  Future<String> createF(AdminReport report) async {
    DocumentReference docRef = _reportCollections.doc();
    String docId = docRef.id;

    await docRef.set(report.toMap(report.idSignalement));
    return docId;
  }

  @override
  Future<AdminReport?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _reportCollections.doc(id).get();
      if (docSnapshot.exists) {
        return AdminReport.fromFirestore(docSnapshot);
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
  Future<void> updateF(AdminReport report) async {
    try {
      if (report.id == null) {
        return;
      }

      await _reportCollections.doc(report.id).update(report.toMap(report.id!));
    } catch (e) {
      print(
          'Une erreur est survenue lors de la mise à jour du signalement : $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteF(String reportId) async {
    await _reportCollections.doc(reportId).delete();
  }

  @override
  AdminReport getNew() {
    return AdminReport(
      id: "",
      codeCip: "",
      dateReport: null,
      dateProcessing: null,
      denomination: "",
      shape: "",
      idSignalement: "",
      image: "",
      brand: "",
      idPharmacy: null,
      quantityGot: 0,
      quantityAsked: 0,
      statut: null,
      idUser: "",
      routeAdministration: "",
    );
  }

  @override
  Stream<AdminReport?> getByIdS(String id) {
    try {
      return _reportCollections.doc(id).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return AdminReport.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération des signalements : $e');
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
      throw e;
    }
  }
}
