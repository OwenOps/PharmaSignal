import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/views/identification/identification_view.dart';
import 'package:pharma_signal/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkIfUserIsLoggedIn(),
      builder: (context, AsyncSnapshot<bool?> snapshot) {
        final bool isLoggedIn = snapshot.data ?? false;
        if (isLoggedIn) {
          return FutureBuilder(
            future: _authenticate(),
            builder: (context, AsyncSnapshot<bool> authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (authSnapshot.data == true) {
                return const UserNavigationBar();
              } else {
                return const IdentificationView();
              }
            },
          );
        } else {
          return const IdentificationView();
        }
      },
    );
  }

  Future<bool> _checkIfUserIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final UserService userService = UserService();
    final String? uid = prefs.getString('uid');
    Data.user_uid = prefs.getString('uid') ?? "";

    if (uid != null) {
      AppUser? appUser = await userService.getByIdF(uid);
      Data.user = appUser;
    }
    return uid != null;
  }

  Future<bool> _authenticate() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isAuthenticated = await localAuthentication.authenticate(
      localizedReason: 'Veuillez authentifier pour accéder à l\'application',
    );
    return isAuthenticated;
  }
}