import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/profil/help_support/help_support_view.dart';
import 'package:pharma_signal/views/profil/account_information/account_information_view.dart';
import 'package:pharma_signal/views/profil/pharmacy_map/pharmacy_map_view.dart';
import 'package:pharma_signal/views/profil/emergency/emergency_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/widgets/language_dropdown.dart';
import 'package:pharma_signal/widgets/section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfilView extends StatelessWidget {
  const UserProfilView({super.key});

  void _logOut(BuildContext context) {
    WidgetFunction.resetPreferences();
    resetUserConnection();
    WidgetFunction.goToTheFirstPage(context);
  }

  void resetUserConnection() async {
    UserService userService = UserService();
    AppUser? appUser = await userService.getByIdF(Data.user_uid);

    appUser?.isConnected = false;

    userService.updateF(appUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 15),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    AppLocalizations.of(context)?.myAccount ?? Constants.notAvailable,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => _logOut(context),
                      icon: const Icon(Icons.logout_outlined),
                      tooltip: AppLocalizations.of(context)?.login ?? Constants.notAvailable,
                    )
                  ],
                ),
                const _Account(),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 15),
                  child: const _OtherLinks(),
                ),
                Container(
                  width: 200,
                  margin: const EdgeInsets.only(top: 50),
                  child: const LanguageDropdown(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtherLinks extends StatelessWidget {
  const _OtherLinks();

  void _goToPharmacy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PharmacyMapView()),
    );
  }

  void _goToEmergency(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyView()),
    );
  }

  void _goToHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpSupportView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionLinksDescription(
            icon: const Icon(
              Icons.medical_services_rounded,
              color: Constants.darkBlue,
            ),
            title: AppLocalizations.of(context)?.myPharmacies ?? Constants.notAvailable,
            onTapFunction: () => _goToPharmacy(context),
            descriptionSection: AppLocalizations.of(context)?.pharmacyDescription ?? Constants.notAvailable),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
        SectionLinksDescription(
            icon: const Icon(Icons.warning, color: Constants.darkBlue),
            title: AppLocalizations.of(context)?.helpNumber ?? Constants.notAvailable,
            onTapFunction: () => _goToEmergency(context),
            descriptionSection: AppLocalizations.of(context)?.emergencyDescription ?? Constants.notAvailable),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
        SectionLinksDescription(
            icon: const Icon(Icons.support_agent_outlined,
                color: Constants.darkBlue),
            title: AppLocalizations.of(context)?.helpSupport ?? Constants.notAvailable,
            onTapFunction: () => _goToHelpSupport(context),
            descriptionSection: AppLocalizations.of(context)?.helpSupportDescription ?? Constants.notAvailable),
        const Divider(height: 30, thickness: 0.5, endIndent: 30),
      ],
    );
  }
}

class _Account extends StatefulWidget {
  const _Account({super.key});

  @override
  State<_Account> createState() => __AccountState();
}

class __AccountState extends State<_Account> {
  final UserService userService = UserService();
  late AppUser user;
  String? firstLastName = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    try {
      late AppUser? appUserTmp;

      if (Data.user == null) {
        appUserTmp = await userService.getByIdF(Data.user_uid);
      } else {
        appUserTmp = Data.user;
      }

      setState(() {
        user = appUserTmp!;
        firstLastName = WidgetFunction.concatName(
            Data.user?.lastName, Data.user?.firstName);
      });
    } catch (e) {
      WidgetFunction.showADialog(AppLocalizations.of(context)?.errorHappened ?? Constants.notAvailable, AppLocalizations.of(context)?.errorFetchUser ?? Constants.notAvailable, context);
    }
  }

  void _goToInformationAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountInformationView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                firstLastName.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.mail.toString()),
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)?.seeMyAccount ?? Constants.notAvailable,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _goToInformationAccount(context),
                  mouseCursor: SystemMouseCursors.click,
                  style: const TextStyle(
                    color: Constants.darkBlue,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: ArrowLink(onTap: () => _goToInformationAccount(context))),
        ],
      ),
    );
  }
}
