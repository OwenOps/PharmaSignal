import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_application/models/user_admin.dart';
import 'package:mobile_application/services/user_admin_service.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/utils/functions.dart';
import 'package:mobile_application/views/account_login/first_connection_view.dart';
import 'package:mobile_application/views/account_login/password_reset_dialog.dart';
import 'package:mobile_application/views/identification/identification_view.dart';
import 'package:mobile_application/widgets/button.dart';
import 'package:mobile_application/widgets/input_text.dart';
import 'package:mobile_application/widgets/navigation_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  void checkUserLogIn(String email, String uid) async {
    final AdminService userService = AdminService();
    final UserAdmin? appUser = await userService.getByEmail(email);

    if (appUser != null) {
      Data.user = appUser;
      Data.user_uid = uid;

      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const UserNavigationBar(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }
  }

  Future<void> _checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? uid = prefs.getString('uid');

    if (email != null && uid != null) {
      bool isAuthenticated = await _authenticate();
      if (isAuthenticated) {
        checkUserLogIn(email, uid);
      } else {
        WidgetFunction.resetPreferences();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IdentificationView()),
        );
      }
    }
  }

  Future<bool> _authenticate() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isAuthenticated = await localAuthentication.authenticate(
      localizedReason: 'Veuillez authentifier pour accéder à l\'application',
    );
    return isAuthenticated;
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.adminDarkBlue,
          title: const Text("Réinitialisation du mot de passe",
              style: TextStyle(fontSize: 20, color: Constants.white)),
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
              child: const Text("Fermer",
                  style: TextStyle(color: Constants.white)),
            ),
          ],
        );
      },
    );
  }

  void checkError(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      WidgetFunction.showADialog(
          "Utilisateur non trouvé. Veuillez vous inscrire.",
          "Erreur de Connexion",
          context);
    } else if (e.code == 'wrong-password') {
      WidgetFunction.showADialog(
          "Mot de passe incorrect.", "Erreur de Connexion", context);
    } else {
      WidgetFunction.showADialog(
          "Erreur de connexion: ${e.message}", "Erreur de Connexion", context);
    }
  }

  void checkUserConnection(
      AdminService userService, String email, String password) async {
    final UserAdmin? appUser = await userService.getByEmail(email);

    if (appUser == null) {
      WidgetFunction.showADialog(
          "L'Utilisateur n'a pas été trouvé.", "Erreur de connexion", context);
      return;
    }

    if (appUser.firstConnection == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FirstConnectionView(
                    adminUser: appUser,
                    password: password,
                  )));
    } else {
      Data.user = appUser;
      WidgetFunction.goToThePage(context, const UserNavigationBar());
    }
  }

  void setPreferences(UserCredential userCredential, String email) async {
    Data.user_uid = userCredential.user!.uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', Data.user_uid);
    await prefs.setString('email', email);
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
      final AdminService userService = AdminService();
      final UserAdmin? existingUser = await userService.getByEmail(email);

      if (existingUser == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setPreferences(userCredential, email);
      checkUserConnection(userService, email, password);
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
      backgroundColor: Constants.adminDarkBlue,
      appBar: AppBar(
        backgroundColor: Constants.adminDarkBlue,
        iconTheme: const IconThemeData(
          color: Constants.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 70, bottom: 100),
                  child: SvgPicture.asset(
                    'assets/img/logo/logo-capsule.svg',
                    height: MediaQuery.of(context).size.height * 0.18,
                  )),
              InputTextWithEmailFormatValidator(
                  description: "Email",
                  iconique: const Icon(Icons.email),
                  controller: _emailController),
              const SizedBox(height: 20.0),
              InputTextWithVisibilityToggle(
                  description: "Mot de passe",
                  iconique: const Icon(Icons.remove_red_eye),
                  controller: _passwordController),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.only(right: 190),
                child: TextButton(
                  onPressed: () => _openDialog(context),
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: Constants.lightGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              BlueButton(
                  description: "Se connecter",
                  onPressed: () => validationConnexion(context)),
            ],
          ),
        ),
      ),
    );
  }
}
