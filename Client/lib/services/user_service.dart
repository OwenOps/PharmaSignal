import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/report.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';

class UserService
    implements CrudFutureService<AppUser>, CrudStreamService<AppUser> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('utilisateurs');

  @override
  Future<String> createF(AppUser user) async {
    try {
      DocumentReference docRef = await _usersCollection.add(user.toMap());
      return docRef.id;
    } catch (e) {
      print('Erreur lors de la création de l\'utilisateur : $e');
      rethrow;
    }
  }

  Future<String> createFR(AppUser user, Report report) async {
    try {
      DocumentReference userDocRef = await _usersCollection.add(user.toMap());
      String userId = userDocRef.id;

      await userDocRef.collection('signalements').add(report.toMap());
      return userId;
    } catch (e) {
      print(
          'Erreur lors de la création de l\'utilisateur avec le rapport : $e');
      rethrow;
    }
  }

  Future<AppUser?> getUserWithReportsOnce(String userId) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) return null;

      AppUser user = AppUser.fromFirestore(userDoc);

      QuerySnapshot reportsSnapshot =
          await _usersCollection.doc(userId).collection('signalements').get();
      user.signalement =
          reportsSnapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
      return user;
    } catch (e) {
      print(
          'Erreur lors de la récupération de l\'utilisateur avec les signalements : $e');
      rethrow;
    }
  }

  @override
  Future<AppUser?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _usersCollection.doc(id).get();
      if (docSnapshot.exists) {
        return AppUser.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      rethrow;
    }
  }

  Stream<AppUser?> getUserWithReportsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists) return null;

      AppUser user = AppUser.fromFirestore(userDoc);

      QuerySnapshot reportsSnapshot =
          await userDoc.reference.collection('signalements').get();
      user.signalement =
          reportsSnapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();

      return user;
    });
  }

  @override
  Stream<AppUser?> getByIdS(String id) {
    try {
      return _usersCollection.doc(id).snapshots().map((docSnapshot) {
        return AppUser.fromFirestore(docSnapshot);
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération de l\'utilisateur: $e');
      rethrow;
    }
  }

  Future<void> updateFR(AppUser user, Report report) async {
    try {
      DocumentReference userDocRef = _usersCollection.doc(user.id);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      if (!userSnapshot.exists) {
        throw Exception("L'utilisateur n'existe pas dans la base de données.");
      }

      CollectionReference reportCollectionRef =
          userDocRef.collection('signalements');

      DocumentSnapshot reportSnapshot =
          await reportCollectionRef.doc(report.id).get();
      if (!reportSnapshot.exists) {
        throw Exception(
            "Le signalement à mettre à jour n'existe pas dans la liste de l'utilisateur.");
      }

      await reportCollectionRef.doc(report.id).update(report.toMap());
    } catch (e) {
      print(
          'Une erreur est survenue lors de la mise à jour du signalement : $e');
      throw e;
    }
  }

  Future<String> addReportToUser(AppUser user, Report report) async {
    try {
      DocumentReference userDocRef = _usersCollection.doc(user.id);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      if (!userSnapshot.exists) {
        throw Exception("L'utilisateur n'existe pas dans la base de données.");
      }

      DocumentReference reportDocRef = await userDocRef.collection('signalements').add(report.toMap());

      return reportDocRef.id;
    } catch (e) {
      print(
          "Une erreur s'est produite lors de l'ajout du rapport à l'utilisateur : $e");
    }
    return "null";
  }

  @override
  Future<List<Map<String, dynamic>>> getAllF() async {
    QuerySnapshot querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> updateF(AppUser user) async {
    if (user.id == null) {
      return;
    }

    await _usersCollection.doc(user.id).update(user.toMap());
  }

  @override
  Future<void> deleteF(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  @override
  Stream<QuerySnapshot> getAllS() {
    try {
      return _usersCollection.snapshots();
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération des utilisateurs: $e');
      throw e;
    }
  }

  @override
  AppUser getNew() {
    return AppUser(
        id: "", firstName: "", lastName: "", mail: "", isConnected: true);
  }

  Future<AppUser?> getMedicament(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('mail', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        return AppUser.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur: $e");
      rethrow;
    }
  }
}
