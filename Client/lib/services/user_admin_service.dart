import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma_signal/models/user_admin.dart';
import 'package:pharma_signal/services/crud_future_service.dart';
import 'package:pharma_signal/services/crud_stream_service.dart';

class AdminService
    implements CrudFutureService<UserAdmin>, CrudStreamService<UserAdmin> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('admin_utilisateurs');

  @override
  Future<String> createF(UserAdmin user) async {
    DocumentReference docRef = await _usersCollection.add(user.toMap());
    return docRef.id;
  }

  @override
  Future<UserAdmin?> getByIdF(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _usersCollection.doc(id).get();
      if (docSnapshot.exists) {
        return UserAdmin.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllF() async {
    QuerySnapshot querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> updateF(UserAdmin user) async {
    try {
      if (user.id == null) {
        return;
      }

      Map<String, dynamic> userMap = user.toMap();
      await _usersCollection.doc(user.id).update(userMap);
    } catch (e) {
      print(
          'Une erreur est survenue lors de la mise à jour de l\'utilisateur : $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteF(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  @override
  UserAdmin getNew() {
    return UserAdmin(
        id: "", lastName: "", firstName: "", mail: "", firstConnection: true);
  }

  @override
  Stream<UserAdmin?> getByIdS(String id) {
    try {
      return _usersCollection.doc(id).snapshots().map((docSnapshot) {
        return UserAdmin.fromFirestore(docSnapshot);
      });
    } catch (e) {
      print(
          'Une erreur est survenue lors de la récupération de l\'utilisateur : $e');
      rethrow;
    }
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
}
