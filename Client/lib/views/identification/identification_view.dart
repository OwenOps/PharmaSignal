import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pharma_signal/views/create_account/create_account_view.dart';
import 'package:pharma_signal/views/identification/condition_view.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/language_dropdown.dart';
import '../account_login/account_login_view.dart';
import 'package:pharma_signal/utils/constants.dart';

class IdentificationView extends StatelessWidget {
  const IdentificationView({super.key});

  void goToAccountLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountLoginView()),
    );
  }

  void goToCreateAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/img/page_accueil/logo.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.52,
            ),
            BigBlueButton(
              onPressed: () => goToAccountLogin(context),
              description:
                  AppLocalizations.of(context)?.login ?? Constants.notAvailable,
            ),
            const SizedBox(height: 25),
            BigWhiteButton(
              onPressed: () => goToCreateAccount(context),
              description: AppLocalizations.of(context)?.createAccount ?? Constants.notAvailable,
            ),
            const SizedBox(height: 35),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConditionView(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)?.chartres ?? Constants.notAvailable,
                style: const TextStyle(
                  color: Constants.darkBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const LanguageDropdown(),
          ],
        ),
      ),
    );
  }
}
