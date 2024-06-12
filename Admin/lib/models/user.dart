import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_application/models/report.dart';

class AppUser {
  String? id;
  String? firstName;
  String? lastName;
  String? mail;
  bool? isConnected;
  List<Report>? signalement;

  AppUser({
    this.id,
    this.firstName,
    this.lastName,
    this.mail,
    this.isConnected,
    this.signalement,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      mail: data['mail'],
      isConnected: data['isConnected'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mail': mail,
      'isConnected': isConnected,
    };
  }
}
