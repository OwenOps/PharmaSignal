import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/drop_down.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:pharma_signal/widgets/tiltle_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
              title: Text(AppLocalizations.of(context)?.myAccount ?? Constants.notAvailable,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 25),
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 32, bottom: 15),
                  child: const DeleteDescription(),
                ),
                const _DeleteForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteDescription extends StatelessWidget {

  const DeleteDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: AppLocalizations.of(context)?.deleteAccount ?? Constants.notAvailable),
        Text(
          AppLocalizations.of(context)?.areYouSureWantLeave ?? Constants.notAvailable,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(padding: const EdgeInsets.only(right: 10, top: 5), child: Text(AppLocalizations.of(context)?.deleteYourData ?? Constants.notAvailable))
        ,
      ],
    );
  }
}

class _DeleteForm extends StatefulWidget {
  const _DeleteForm();

  @override
  State<_DeleteForm> createState() => __DeleteFormState();
}

class __DeleteFormState extends State<_DeleteForm> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final UserService userService = UserService();

  var selectedOptions = "";

  List<String> getOptions(BuildContext context) {
    List<String> options = [
      AppLocalizations.of(context)?.dontUseApplication ?? Constants.notAvailable,
      AppLocalizations.of(context)?.tooSlow ?? Constants.notAvailable,
      AppLocalizations.of(context)?.missingFunc ?? Constants.notAvailable,
      AppLocalizations.of(context)?.other ?? Constants.notAvailable
    ];
    return options;
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void confirmDelete() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final passwordValue = passwordController.text;

    if (await deleteUserData(user, passwordValue, context)) {
      WidgetFunction.goToTheFirstPage(context);
    }
  }

  Future<bool> deleteUserData(
      User user, String passwordValue, BuildContext context) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: passwordValue,
      );
      await user.reauthenticateWithCredential(credential);

      await user.delete();
      await userService.deleteF(user.uid);

      WidgetFunction.resetPreferences();
      Data.setDefaultUid();

      return true;
    } catch (e) {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.errorDuringDelete ?? Constants.notAvailable, AppLocalizations.of(context)?.error ?? Constants.notAvailable, context);
      return false;
    }
  }

  void changeValueDropDown(String? newValue) {
    setState(() {
      selectedOptions = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                InputTextWithVisibilityToggle(
                    description: AppLocalizations.of(context)?.password ?? Constants.notAvailable,
                    controller: passwordController,
                    iconique: const Icon(Icons.remove_red_eye),
                    ),
                Center(
                  child: SizedBox(
                    child: DefaultDropDown(
                      titleDropdown: AppLocalizations.of(context)?.reasons ?? Constants.notAvailable,
                      options: getOptions(context),
                      selectedOption: selectedOptions,
                      onChanged: changeValueDropDown,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RedButtonWarning(
                  description: AppLocalizations.of(context)?.deleteAccount ?? Constants.notAvailable,
                  onPressed: confirmDelete,
                ),
              ],
            )));
  }
}
