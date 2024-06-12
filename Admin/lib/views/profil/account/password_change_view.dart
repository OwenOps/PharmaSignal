import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/utils/functions.dart';
import 'package:mobile_application/widgets/button.dart';
import 'package:mobile_application/widgets/input_text.dart';
import 'package:mobile_application/widgets/tiltle_text.dart';

class PasswordChangeView extends StatelessWidget {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.adminDarkBlue,
      body: Column(
        children: [
          AppBar(
            title: const Text(
              "Mon Profil",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Constants.white),
            ),
            backgroundColor: Constants.adminDarkBlue,
            iconTheme: const IconThemeData(
              color: Constants.white,
            ),
          ),
          const SizedBox(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: const PasswordChangeDescription(),
              ),
              const _PasswordChangeForm(),
            ],
          ),
        ],
      ),
    );
  }
}

class PasswordChangeDescription extends StatelessWidget {
  const PasswordChangeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const TitleText(title: "Modifier mon mot de passe", fontSize: 22);
  }
}

class _PasswordChangeForm extends StatefulWidget {
  const _PasswordChangeForm();

  @override
  State<_PasswordChangeForm> createState() => _PasswordChangeFormState();
}

class _PasswordChangeFormState extends State<_PasswordChangeForm> {
  final _formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controllers = {
    'oldPassword': TextEditingController(),
    'newPassword': TextEditingController(),
    'confirmNewPassword': TextEditingController(),
  };

  final String descriptionHint = "Mot de passe";
  final String descriptionInput1 = "Ancien mot de passe";
  final String descriptionInput2 = "Nouveau mot de passe";
  final String descriptionInput3 = "Confirmer le nouveau mot de passe";

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void confirmPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldPassword = controllers['oldPassword']!.text;
    final newPassword = controllers['newPassword']!.text;
    final confirmNewPassword = controllers['confirmNewPassword']!.text;

    if (await changePassword(
        oldPassword, newPassword, confirmNewPassword, context)) {
      Navigator.pop(context);
    }
  }

  Future<bool> changePassword(String oldPass, String newPass,
      String confirmPass, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    if (!WidgetFunction.passwordsMatched(newPass, confirmPass)) {
      WidgetFunction.showADialog(
          "Le nouveau et l'ancien mot de passe ne correspondent pas.",
          "Erreur",
          context);
      return false;
    }

    if (!WidgetFunction.isValidPassword(newPass)) {
      WidgetFunction.showADialog(
          "Le mot de passe doit contenir au moins 8 caractères, incluant au moins une minuscule, une majuscule, un chiffre et un caractère spécial.",
          "Erreur",
          context);
      return false;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPass);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPass);
      return true;
    } catch (e) {
      WidgetFunction.showADialog(
          "L'ancien mot de passe est incorrect", "Erreur", context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(children: [
            InputTextWithVisibilityToggle(
              description: descriptionInput1,
              controller: controllers['oldPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            const SizedBox(height: 20),
            InputTextWithVisibilityToggle(
              description: descriptionInput2,
              controller: controllers['newPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            const SizedBox(height: 20),
            InputTextWithVisibilityToggle(
              description: descriptionInput3,
              controller: controllers['confirmNewPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            const SizedBox(height: 20),
            BlueButton(
              onPressed: () => confirmPassword(context),
              description: "Modifier",
            )
          ]),
        ));
  }
}
