import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/account_login/password_reset_dialog.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:pharma_signal/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountLoginView extends StatefulWidget {
  const AccountLoginView({super.key});

  @override
  _AccountLoginViewState createState() => _AccountLoginViewState();
}

class _AccountLoginViewState extends State<AccountLoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isButtonDisabled = false;

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)?.resetPassword ??
                  Constants.notAvailable,
              style: const TextStyle(
                fontSize: 20,
              )),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: const PasswordResetDialog(),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.close ??
                  Constants.notAvailable),
            ),
          ],
        );
      },
    );
  }

  void setPreferences(UserCredential userCredential) async {
    Data.user_uid = userCredential.user!.uid;

    WidgetFunction.setPreferences();
  }

  void checkUser(String email) async {
    final UserService userService = UserService();

    AppUser? appUser = await userService.getByIdF(Data.user_uid);

    if(!mounted) return;

    if (appUser!.isConnected == true) {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.accountAlreadyConnected ??
              Constants.notAvailable,
          AppLocalizations.of(context)?.errorConnection ??
              Constants.notAvailable,
          context);
      return;
    }

    if (appUser.mail != email) {
      appUser.mail = email;
      appUser.isConnected = true;
      await userService.updateF(appUser);
    }

    Data.user = appUser;
  }

  void checkError(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.userNotFound ?? Constants.notAvailable,
          AppLocalizations.of(context)?.errorConnection ??
              Constants.notAvailable,
          context);
    } else if (e.code == 'wrong-password') {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.wrongPassword ?? Constants.notAvailable,
          AppLocalizations.of(context)?.errorConnection ??
              Constants.notAvailable,
          context);
    } else {
      WidgetFunction.showADialog(
          AppLocalizations.of(context)?.errorConnection ??
              "${Constants.notAvailable}${e.message}",
          AppLocalizations.of(context)?.errorConnection ??
              Constants.notAvailable,
          context);
    }
  }

  void validationConnexion(BuildContext context) async {
    if (_isButtonDisabled) {
      return;
    }

    setState(() {
      _isButtonDisabled = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setPreferences(userCredential);
      checkUser(email);

      WidgetFunction.goToThePageWithNav(context, const UserNavigationBar());

    } on FirebaseAuthException catch (e) {
      checkError(e);
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/img/logo/logo.svg',
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.45,
              ),
              InputTextWithEmailFormatValidator(
                  description: AppLocalizations.of(context)?.email ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.email),
                  controller: _emailController),
              const SizedBox(height: 20.0),
              InputTextWithVisibilityToggle(
                  description: AppLocalizations.of(context)?.password ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.remove_red_eye),
                  controller: _passwordController),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.only(right: 190),
                child: TextButton(
                  onPressed: () => _openDialog(context),
                  child: Text(
                    AppLocalizations.of(context)?.forgotPassword ??
                        Constants.notAvailable,
                    style: const TextStyle(
                      color: Color(0xFFBEBEBE),
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              BlueButton(
                description: AppLocalizations.of(context)?.login ??
                    Constants.notAvailable,
                onPressed: _isButtonDisabled
                    ? null
                    : () => validationConnexion(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
