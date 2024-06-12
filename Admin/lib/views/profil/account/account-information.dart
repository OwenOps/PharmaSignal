import 'package:flutter/material.dart';
import 'package:mobile_application/models/user_admin.dart';
import 'package:mobile_application/services/user_admin_service.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/utils/functions.dart';
import 'package:mobile_application/views/profil/account/password_change_view.dart';
import 'package:mobile_application/widgets/section.dart';

class AccountInformationView extends StatelessWidget {
  const AccountInformationView({super.key});

  void _logOut(BuildContext context) {
    WidgetFunction.resetPreferences();
    WidgetFunction.goToTheFirstPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.adminDarkBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: const Text(
                "Mon compte",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Constants.white),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () => _logOut(context),
                  icon: const Icon(Icons.logout_outlined, color: Constants.white),
                  tooltip: "Se déconnecter",
                )
              ],
              backgroundColor: Constants.adminDarkBlue,
            ),
            Center(
              child: Column(
                children: [
                  const UserAccount(),
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: const _UserFormulaire(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  AdminService userService = AdminService();
  late UserAdmin? userAdmin;

  String? firstLastName = "";
  String? lastName = "";
  String? firstName = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    late UserAdmin? userAdminTmp;
    if (Data.user == null) {
      userAdminTmp = await userService.getByIdF(Data.user_uid);
    } else {
      userAdminTmp = Data.user;
    }

    setState(() {
      userAdminTmp = userAdminTmp;
      lastName = userAdminTmp?.lastName;
      firstName = userAdminTmp?.firstName;
      firstLastName = WidgetFunction.concatName(firstName, lastName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                firstLastName.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text('$firstName $lastName',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Constants.white)),
          )
        ],
      ),
    );
  }
}

class _UserFormulaire extends StatelessWidget {
  const _UserFormulaire();

  void _goToNewPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordChangeView()),
    );
  }

  final String deleteAccountDescription =
      "Supprimez votre compte si vous ne voulez plus utiliser l'application.";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionLinksNoDescription(
            icon: const Icon(Icons.password, color: Constants.darkBlue),
            title: "Modifier mon mot de passe",
            onTapFunction: () => _goToNewPassword(context)),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
      ],
    );
  }
}
