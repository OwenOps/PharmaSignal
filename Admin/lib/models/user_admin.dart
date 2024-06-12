import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdmin {
  String? id;
  String? lastName;
  String? firstName;
  String? mail;
  bool? firstConnection;

  UserAdmin(
      {this.id,
      this.lastName,
      this.firstName,
      this.mail,
      this.firstConnection});

  factory UserAdmin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    return UserAdmin(
      id: doc.id,
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      mail: userData['mail'],
      firstConnection: userData['firstConnexion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'mail': mail,
      'firstConnexion': firstConnection
    };
  }
}
