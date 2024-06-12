import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:pharma_signal/widgets/tiltle_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MailChangeView extends StatelessWidget {
  const MailChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
              title: Text(AppLocalizations.of(context)?.myAccount ?? Constants.notAvailable,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 25),
          const Center(
            child: Column(
              children: [
                MailChangeDescription(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MailChangeDescription extends StatelessWidget {
  const MailChangeDescription({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 35),
          child: TitleText(title: AppLocalizations.of(context)?.changeEmail ?? Constants.notAvailable, fontSize: 22) ,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left:35, right: 10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)?.changeMailDeconnect ?? Constants.notAvailable,
                  style: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)?.deconnectUpper ?? Constants.notAvailable,
                  style: const TextStyle(color: Colors.red, fontFamily: "Poppins", fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)?.yourAccount ?? Constants.notAvailable,
                  style: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
                ),
              ],
            ),
          ),
        ),
        const _MailChangeForm(),
      ],
    );
  }
}

class _MailChangeForm extends StatefulWidget {
  const _MailChangeForm();

  @override
  State<_MailChangeForm> createState() => _MailChangeFormState();
}

class _MailChangeFormState extends State<_MailChangeForm> {
  final _formKey = GlobalKey<FormState>();
  final mailChangeController = TextEditingController();
  final passwordController = TextEditingController();
  final UserService userService = UserService();

  @override
  void dispose() {
    mailChangeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void confirmMail(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final newEmail = mailChangeController.text;
    final passwordValue = passwordController.text;

    if (!WidgetFunction.isValidEmail(newEmail)) {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.chooseGoodEmail ?? Constants.notAvailable, AppLocalizations.of(context)?.error ?? Constants.notAvailable, context);
      return;
    }

    if (await resetEmail(newEmail, passwordValue, user, context)) {
      // Navigator.pop(context);
      WidgetFunction.resetPreferences();
      WidgetFunction.goToTheFirstPage(context);
    }
  }

  Future<bool> resetEmail(String newEmail, String passwordValue, User user,
      BuildContext context) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: passwordValue,
      );

      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);

      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.mailSend ?? Constants.notAvailable,
          AppLocalizations.of(context)?.verification ?? Constants.notAvailable,
          context);

      await Future.delayed(const Duration(seconds: 5));

      return true;
    } catch (e) {
      WidgetFunction.showADialog(AppLocalizations.of(context)?.wrongPassword ?? Constants.notAvailable, AppLocalizations.of(context)?.error ?? Constants.notAvailable, context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(children: [
            InputTextWithEmailFormatValidator(
              description: AppLocalizations.of(context)?.newEmail ?? Constants.notAvailable,
              controller: mailChangeController,
              iconique: const Icon(Icons.email),
            ),
            InputTextWithVisibilityToggle(
              description: AppLocalizations.of(context)?.password ?? Constants.notAvailable,
              controller: passwordController,
              iconique: const Icon(Icons.remove_red_eye),
            ),
            BlueButton(
              onPressed: () => confirmMail(context),
              description: AppLocalizations.of(context)?.change ?? Constants.notAvailable,
            )
          ]),
        ));
  }
}
