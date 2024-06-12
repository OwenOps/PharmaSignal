import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/profil/account_information/account_settings/delete_account_view.dart';
import 'package:pharma_signal/views/profil/account_information/account_settings/mail_change_view.dart';
import 'package:pharma_signal/views/profil/account_information/account_settings/password_change_view.dart';
import 'package:pharma_signal/widgets/section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountInformationView extends StatelessWidget {
  const AccountInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text(AppLocalizations.of(context)?.myAccount ?? Constants.notAvailable,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Center(
          child: Column(
            children: [
              const _UserAccount(),
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

class _UserAccount extends StatefulWidget {
  const _UserAccount();

  @override
  State<_UserAccount> createState() => __UserAccountState();
}

class __UserAccountState extends State<_UserAccount> {
  UserService userService = UserService();
  late AppUser? appUser;

  String? firstLastName = "";
  String? lastName = "";
  String? firstName = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    late AppUser? appUserTmp;
    if (Data.user == null) {
      appUserTmp = await userService.getByIdF(Data.user_uid);
    } else {
      appUserTmp = Data.user;
    }

    setState(() {
      appUser = appUserTmp;
      lastName = appUser?.lastName;
      firstName = appUser?.firstName;
      firstLastName = WidgetFunction.concatName(lastName, firstName);
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
            child: Text('$lastName $firstName ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }
}

class _UserFormulaire extends StatelessWidget {
  const _UserFormulaire();

  void _goToNewEmail(BuildContext context) async {
    bool isAuthenticated = await _authenticate(context);
    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MailChangeView()),
      );
    }
  }

  void _goToNewPassword(BuildContext context) async {
    bool isAuthenticated = await _authenticate(context);
    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PasswordChangeView()),
      );
    }
  }

  void _goToDeleteAccount(BuildContext context) async {
    bool isAuthenticated = await _authenticate(context);
    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DeleteAccountView()),
      );
    }
  }

  Future<bool> _authenticate(BuildContext context) async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isAuthenticated = await localAuthentication.authenticate(
      localizedReason: AppLocalizations.of(context)?.authenticate ?? Constants.notAvailable,
    );
    return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionLinksNoDescription(
            icon: const Icon(
              Icons.alternate_email_rounded,
              color: Constants.darkBlue,
            ),
            title: AppLocalizations.of(context)?.changeEmail ??
                Constants.notAvailable,
            onTapFunction: () => _goToNewEmail(context)),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
        SectionLinksNoDescription(
            icon: const Icon(Icons.password, color: Constants.darkBlue),
            title: AppLocalizations.of(context)?.changePassword ??
                Constants.notAvailable,
            onTapFunction: () => _goToNewPassword(context)),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
        SectionLinksDescription(
          icon: const Icon(Icons.warning, color: Constants.darkBlue),
          title: AppLocalizations.of(context)?.deleteAccount ??
              Constants.notAvailable,
          onTapFunction: () => _goToDeleteAccount(context),
          descriptionSection: AppLocalizations.of(context)?.deleteYouAccount ??
              Constants.notAvailable,
        ),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
      ],
    );
  }
}
