import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void showResetLink(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.resetLinkSend ??
            "${Constants.notAvailable}$email"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      ),
    );
    Navigator.of(context).pop();
  }

  void showErrorSendingLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.errorSendingLink ??
            Constants.notAvailable),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text;

    if (email.isNotEmpty && _isValidEmail(email)) {
      try {
        _auth.sendPasswordResetEmail(email: email);

        showResetLink(email);
      } catch (e) {
        showErrorSendingLink();
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          InputTextWithEmailFormatValidator(
              description: AppLocalizations.of(context)?.emailAdress ??
                  Constants.notAvailable,
              iconique: const Icon(Icons.email),
              controller: _emailController),
          const SizedBox(height: 10),
          BlueButton(
              description:
                  AppLocalizations.of(context)?.send ?? Constants.notAvailable,
              onPressed: () => _resetPassword(context)),
        ],
      ),
    );
  }
}
