import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CrudStreamService<T> {
  Stream<T?> getByIdS(String id);
  Stream<QuerySnapshot> getAllS();
}