import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:pharma_signal/widgets/tiltle_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordChangeView extends StatelessWidget {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
              title: Text(AppLocalizations.of(context)?.seeMyAccount ?? Constants.notAvailable,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: const PasswordChangeDescription()),
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
          AppLocalizations.of(context)?.passwordDontMatch ?? Constants.notAvailable,
          AppLocalizations.of(context)?.error ?? Constants.notAvailable,
          context);
      return false;
    }

    if (!WidgetFunction.isValidPassword(newPass)) {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.passwordNeeds ?? Constants.notAvailable,
          AppLocalizations.of(context)?.error ?? Constants.notAvailable,
          context);
      return false;
    }

    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: oldPass);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPass);
      return true;
    } catch (e) {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.wrongOldPassword ?? Constants.notAvailable, AppLocalizations.of(context)?.error ?? Constants.notAvailable, context);
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
              description: AppLocalizations.of(context)?.oldPassword ?? Constants.notAvailable,
              controller: controllers['oldPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            InputTextWithVisibilityToggle(
              description: AppLocalizations.of(context)?.newPassword ?? Constants.notAvailable,
              controller: controllers['newPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            InputTextWithVisibilityToggle(
              description: AppLocalizations.of(context)?.confirmNewPassword ?? Constants.notAvailable,
              controller: controllers['confirmNewPassword'],
              iconique: const Icon(Icons.remove_red_eye),
            ),
            BlueButton(
              onPressed: () => confirmPassword(context),
              description: AppLocalizations.of(context)?.change ?? Constants.notAvailable,
            )
          ]),
        ));
  }
}
