import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/account_login/account_login_view.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:pharma_signal/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  _CreateAccountViewState createState() => _CreateAccountViewState();
}

class WidgetSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const WidgetSwitch({super.key, required this.initialValue, this.onChanged});

  @override
  State<WidgetSwitch> createState() => _WidgetSwitchState();
}

class _WidgetSwitchState extends State<WidgetSwitch> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      activeColor: const Color(0xFF317AC1),
      inactiveTrackColor: Constants.white,
    );
  }
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _switch1Value = false;
  bool _switch2Value = false;

  void _showErrorDialog(String message) {
    setState(() {});

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
              AppLocalizations.of(context)?.error ?? Constants.notAvailable),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            BlueButtonPop(
              description:
                  AppLocalizations.of(context)?.retry ?? Constants.notAvailable,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void verifCase(BuildContext context) {
    if (_familyNameController.text.isEmpty ||
        _firstNameController.text.isEmpty) {
      _showErrorDialog(AppLocalizations.of(context)?.chooseNameFirstName ??
          Constants.notAvailable);
      return;
    }

    if (!WidgetFunction.isValidEmail(_emailController.text)) {
      _showErrorDialog(AppLocalizations.of(context)?.chooseGoodEmail ??
          Constants.notAvailable);
      return;
    }

    if (!WidgetFunction.isValidPassword(_passwordController.text)) {
      _showErrorDialog(AppLocalizations.of(context)?.passwordNeeds ??
          Constants.notAvailable);
      return;
    }

    if (!WidgetFunction.passwordsMatched(
        _passwordController.text, _confirmPasswordController.text)) {
      _showErrorDialog(AppLocalizations.of(context)?.passwordDontMatch ??
          Constants.notAvailable);
      return;
    }

    if (!_switch1Value || !_switch2Value) {
      _showErrorDialog(
          AppLocalizations.of(context)?.tickBoxes ?? Constants.notAvailable);
      return;
    }

    _createAccount(context);
  }

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  bool checkError(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.weakPassword ??
              Constants.notAvailable),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.emailAreadyUsed ??
              Constants.notAvailable),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        ),
      );
    }
    return false;
  }

  Future<bool> createUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    UserService userService = UserService();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Data.user_uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(Data.user_uid)
          .set({
        'firstName': capitalize(_familyNameController.text.trim()),
        'lastName': capitalize(_firstNameController.text.trim()),
        'mail': email,
        'isConnected': true
      });

      Data.user = await userService.getByIdF(Data.user_uid);

      WidgetFunction.setPreferences();

      userCredential.user!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {

      checkError(e);

    } catch (e) {
      return false;
    }
    return false;
  }

  void _createAccount(BuildContext context) async {
    if (await createUser()) {
      WidgetFunction.goToThePageWithNav(context, const UserNavigationBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                SvgPicture.asset(
                  'assets/img/logo/logo.svg',
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                InputTextWithIcon(
                  description: AppLocalizations.of(context)?.name ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.account_circle_rounded),
                  controller: _familyNameController,
                ),
                InputTextWithIcon(
                  description: AppLocalizations.of(context)?.firstName ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.account_circle_rounded),
                  controller: _firstNameController,
                ),
                InputTextWithEmailFormatValidator(
                  description: AppLocalizations.of(context)?.email ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.email),
                  controller: _emailController,
                ),
                InputTextWithVisibilityToggle(
                  description: AppLocalizations.of(context)?.password ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.remove_red_eye),
                  controller: _passwordController,
                ),
                InputTextWithVisibilityToggle(
                  description: AppLocalizations.of(context)?.confirmPassword ??
                      Constants.notAvailable,
                  iconique: const Icon(Icons.remove_red_eye),
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)?.alreadyHaveAccount ??
                          Constants.notAvailable,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: '               ',
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)?.login ??
                              Constants.notAvailable,
                          style: const TextStyle(
                            color: Constants.darkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountLoginView()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 350,
                    child: Row(
                      children: [
                        WidgetSwitch(
                          initialValue: _switch1Value,
                          onChanged: (value) {
                            setState(() {
                              _switch1Value = value;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)?.consentsDataShare ??
                                Constants.notAvailable,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 13),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 350,
                    child: Row(
                      children: [
                        WidgetSwitch(
                          initialValue: _switch2Value,
                          onChanged: (value) {
                            setState(() {
                              _switch2Value = value;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)
                                    ?.consentsCreateAccount ??
                                Constants.notAvailable,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 13),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                BlueButton(
                    description: AppLocalizations.of(context)?.createAccount ??
                        Constants.notAvailable,
                    onPressed: () => verifCase(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
