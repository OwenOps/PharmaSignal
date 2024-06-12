import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pharma_signal/models/admin_report.dart';
import 'package:pharma_signal/models/report.dart';
import 'package:pharma_signal/models/status.dart';
import 'package:pharma_signal/services/report_service.dart';
import 'package:pharma_signal/services/reports-admin_service.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/views/identification/identification_view.dart';
import 'package:pharma_signal/widgets/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetFunction {
  static void goToThePageWithNav(BuildContext context, Widget view) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: view,
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void goToThePageWithoutNav(BuildContext context, Widget view) {
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
  }

  static void setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', Data.user_uid);
  }

  static String concatName(String? firstName, String? lastName) {
    return "${firstName?.substring(0, 1)}${lastName?.substring(0, 1)}";
  }

  static void showADialog(
      String errorMessage, String titreDialog, BuildContext context) {
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

  static Future<void> createReport(BuildContext context) async {
    ReportService reportService = ReportService();
    UserService userService = UserService();
    AdminReportService adminReportService = AdminReportService();

    Report reportTmp = reportService.getNew();
    reportTmp.denomination = SignalementMedic.denomination;
    reportTmp.brand = SignalementMedic.marque;
    reportTmp.codeCip = int.tryParse(SignalementMedic.id);
    reportTmp.image = SignalementMedic.image;
    reportTmp.idPharmacy = SignalementMedic.idPharmacy;
    reportTmp.statut = StatusConstant.reported;
    reportTmp.quantityAsked = SignalementMedic.qteDemande;
    reportTmp.dateReport = Timestamp.now();
    reportTmp.shape = SignalementMedic.forme;
    reportTmp.routeAdministration = SignalementMedic.voieAdmin;
    var tmpIdSignalement =
        await userService.addReportToUser(Data.user!, reportTmp);

    AdminReport adminReport = adminReportService.getNew();
    adminReport.codeCip = SignalementMedic.id;
    adminReport.dateReport = reportTmp.dateReport;
    adminReport.dateProcessing = null;
    adminReport.denomination = SignalementMedic.denomination;
    adminReport.shape = SignalementMedic.forme;
    adminReport.idSignalement = tmpIdSignalement;
    adminReport.image = SignalementMedic.image;
    adminReport.brand = SignalementMedic.marque;
    adminReport.idPharmacy = SignalementMedic.idPharmacy;
    adminReport.quantityGot = 1;
    adminReport.quantityAsked = SignalementMedic.qteDemande;
    adminReport.statut = StatusConstant.adminReported;
    adminReport.idUser = Data.user_uid;
    adminReport.routeAdministration = SignalementMedic.voieAdmin;
    await adminReportService.createF(adminReport);
  }

  static Status setStatus(BuildContext context, String status) {
    switch (status) {
      case StatusConstant.terminated:
        return Status(
            color: StatusConstant.terminatedColor,
            statusText: AppLocalizations.of(context)?.terminated ?? "");
      case StatusConstant.inProgress:
        return Status(
            color: StatusConstant.inProgressColor,
            statusText: AppLocalizations.of(context)?.inProgress ?? "");
      case StatusConstant.reported:
        return Status(
            color: StatusConstant.reportedColor,
            statusText: AppLocalizations.of(context)?.reported ?? "");
      default:
        return Status(
            color: StatusConstant.otherColor,
            statusText: AppLocalizations.of(context)?.unknown ?? "");
    }
  }

  static Widget getStatusWidget(BuildContext context, String statusP) {
    Status status = WidgetFunction.setStatus(context, statusP);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status.color,
          ),
        ),
        const SizedBox(width: 8),
        Text(status.statusText),
      ],
    );
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }
}
