import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/button.dart';
import '../account_login/account_login_view.dart';

class IdentificationView extends StatelessWidget {
  const IdentificationView({super.key});

  void goToAccountLogin(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountLoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.adminDarkBlue, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/img/logo/logo-text.svg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.52,
            ),
            BigBlueButton(
              onPressed: () => goToAccountLogin(context),
              description: "Se connecter",
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
