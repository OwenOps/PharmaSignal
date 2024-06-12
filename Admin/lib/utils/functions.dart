import 'package:flutter/material.dart';
import 'package:mobile_application/views/identification/identification_view.dart';
import 'package:mobile_application/widgets/dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetFunction {
  static void goToThePage(BuildContext context, Widget view) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: view,
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void goToTheFirstPage(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const IdentificationView(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void resetPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      await prefs.remove('email');
  }

  static String concatName(String? firstName, String? lastName) {
    return "${firstName?.substring(0, 1)}${lastName?.substring(0, 1)}";
  }

  static void showADialog(String errorMessage, String titreDialog, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          message: errorMessage,
          descriptionButton: "Ok",
          titreDialog: titreDialog,
        );
      },
    );
  }

  static bool isValidEmail(String text) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(text);
  }

  static bool isValidPassword(String text) {
    if (text.length < 8) {
      return false;
    }

    // Vérifier s'il contient au moins une minuscule, une majuscule, un chiffre et un caractère spécial
    final RegExp lowercaseRegex = RegExp(r'[a-z]');
    final RegExp uppercaseRegex = RegExp(r'[A-Z]');
    final RegExp digitRegex = RegExp(r'[0-9]');
    final RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    return lowercaseRegex.hasMatch(text) &&
        uppercaseRegex.hasMatch(text) &&
        digitRegex.hasMatch(text) &&
        specialCharRegex.hasMatch(text);
  }

  static bool passwordsMatched(String password1, String confirmPassword) {
    return password1 == confirmPassword;
  }
}