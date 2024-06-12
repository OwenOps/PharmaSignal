import 'package:flutter/material.dart';
import 'package:mobile_application/models/user_admin.dart';

class Constants {
  static const Color lightBlue = Color(0xFF9AC8EB);
  static const Color darkBlue =  Color(0xFF317AC1); 
  static const Color navBarBlue =  Color(0xFF017afe); 
  static const Color adminDarkBlue =  Color(0xFF0F172A); 
  static const Color adminStatDarkBlue = Color.fromARGB(255, 4, 34, 60);

  static const Color lightGreen =  Color(0xFF83e441);
  static const Color navBarGreen =  Color.fromARGB(255, 95, 168, 47);
  static const Color darkGreen = Color(0xFF3D6F1E);

  static const Color lightGrey =  Color(0xFFBEC1C4);
  static const Color darkGrey =  Color(0xFF72777A);

  static const Color white =  Color(0xFFFFFFFF); 
  static const Color black =  Color(0xFF000000);
}

class Data {
  static String defaultUidValue = "-1";
  static String user_uid = defaultUidValue;
  static String codeCip = "";
  static late UserAdmin? user;
  
  static void setDefaultUid() {
    user_uid = defaultUidValue;
  }
}

