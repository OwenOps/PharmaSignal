import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/widgets/button.dart';
import 'package:mobile_application/widgets/input_text.dart';
class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({super.key});

  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  void _resetPassword(BuildContext context) {
    final email = _emailController.text;

    if (email.isNotEmpty && _isValidEmail(email)) {
      Navigator.of(context).pop();
      _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Lien de réinitialisation envoyé à $email'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          InputTextWithEmailFormatValidator(
              description: "Adresse e-mail",
              iconique: const Icon(Icons.email),
              controller: _emailController),
          const SizedBox(height: 10),
          BlueButton(
              description: 'Envoyer',
              onPressed: () => _resetPassword(context)),
        ],
      ),
    );
  }
}