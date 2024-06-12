import 'package:flutter/material.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Constants {
  static const Color lightBlue = Color(0xFF9AC8EB);
  static const Color darkBlue =  Color(0xFF317AC1); 

  static const Color lightGreen =  Color(0xFF83e441);
  static const Color darkGreen = Color(0xFF3D6F1E);

  static const Color lightGrey =  Color(0xFFBEC1C4);
  static const Color darkGrey =  Color(0xFF72777A);

  static const Color white =  Color(0xFFFFFFFF); 
  static const Color black =  Color(0xFF000000);

  static const String notAvailable = "Not Available";
}

class StatusConstant {
  static const Color terminatedColor =  Colors.green;
  static const Color inProgressColor =  Colors.orange;
  static const Color reportedColor =  Colors.grey;
  static const Color otherColor =  Colors.grey;

  static const String inProgress = "En Cours";
  static const String terminated = "Clôturé";
  static const String reported = "Signalement effectué";
  static const String adminReported = "Signalé";
  static const String unknown = "Inconnu";

  static String getLocalizedStatus(BuildContext context, String status) {
    switch (status) {
      case inProgress:
        return AppLocalizations.of(context)?.inProgress ?? inProgress;
      case terminated:
        return AppLocalizations.of(context)?.terminated ?? terminated;
      case reported:
        return AppLocalizations.of(context)?.reported ?? reported;
      case adminReported:
        return AppLocalizations.of(context)?.adminReported ?? adminReported;
      default:
        return AppLocalizations.of(context)?.unknown ?? unknown;
    }
  }
}

class Data {
  static const String defaultUidValue = "-1";
  static String user_uid = defaultUidValue;
  static late AppUser? user;

  static void setDefaultUid() {
    user_uid = defaultUidValue;
  }
  
  static String dataValue = "";
}

class SignalementMedic{
  static String id ="";
  static String idPharmacy = "";
  static String marque = "";
  static String image = "";
  static String denomination = "";
  static String forme = "";
  static String voieAdmin = "";
  static int? qteDemande = 0;
}

