import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_application/models/user_admin.dart';
import 'package:mobile_application/services/user_admin_service.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/utils/functions.dart';
import 'package:mobile_application/widgets/button.dart';
import 'package:mobile_application/widgets/input_text.dart';
import 'package:mobile_application/widgets/navigation_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FirstConnectionView extends StatefulWidget {
  final UserAdmin adminUser;
  final String password;

  const FirstConnectionView(
      {super.key, required this.adminUser, required this.password});

  @override
  State<FirstConnectionView> createState() => _FirstConnectionViewState();
}

class _FirstConnectionViewState extends State<FirstConnectionView> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  AdminService adminService = AdminService();

  void _resetPassword(BuildContext context) async {
    final newPassword = _newPassword.text;
    final confirmPassword = _confirmPassword.text;

    if (!WidgetFunction.passwordsMatched(newPassword, confirmPassword)) {
      WidgetFunction.showADialog(
          "Le nouveau et l'ancien mot de passe ne correspondent pas.",
          "Erreur",
          context);
      return;
    }

    if (!WidgetFunction.isValidPassword(newPassword)) {
      WidgetFunction.showADialog(
          "Le mot de passe doit contenir au moins 8 caractères, incluant au moins une minuscule, une majuscule, un chiffre et un caractère spécial.",
          "Erreur",
          context);
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        WidgetFunction.showADialog(
            "Erreur lors de la mise à jour de votre mot de passe.",
            "Erreur",
            context);
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: widget.password);

      await user.reauthenticateWithCredential(credential);
      user.updatePassword(newPassword);

      widget.adminUser.firstConnection = false;
      Data.user = widget.adminUser;

      adminService.updateF(widget.adminUser);

      Navigator.of(context).pop();
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const UserNavigationBar(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } catch (e) {
      WidgetFunction.showADialog(
          "Erreur lors de la mise à jour de votre mot de passe.",
          "Erreur",
          context);
      print("--------------------------------");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.adminDarkBlue,
        iconTheme: const IconThemeData(
          color: Constants.white,
        ),
      ),
      backgroundColor: Constants.adminDarkBlue,
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
              const TextDescription(),
              InputTextWithVisibilityToggle(
                  description: "Nouveau mot de passe",
                  iconique: const Icon(Icons.email),
                  controller: _newPassword),
              const SizedBox(height: 20.0),
              InputTextWithVisibilityToggle(
                  description: "Mot de passe",
                  iconique: const Icon(Icons.remove_red_eye),
                  controller: _confirmPassword),
              const SizedBox(height: 25.0),
              BlueButton(
                  description: "Changer",
                  onPressed: () => _resetPassword(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class TextDescription extends StatelessWidget {
  const TextDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Ceci est la ",
                style: TextStyle(color: Constants.white, fontFamily: "Poppins"),
              ),
              TextSpan(
                text: "première fois ",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "que vous vous connectez.",
                style: TextStyle(color: Constants.white, fontFamily: "Poppins"),
              ),
              TextSpan(
                text: "Vous devez donc ",
                style: TextStyle(color: Constants.white, fontFamily: "Poppins"),
              ),
              TextSpan(
                text: "changer",
                style: TextStyle(
                  color: Constants.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(
                text: " votre mot de passe.",
                style: TextStyle(color: Constants.white, fontFamily: "Poppins"),
              ),
            ],
          ),
        ));
  }
}
