import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/views/identification/identification_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase/firebase_options.dart';

void main() async {

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaSignal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants.darkBlue,
        hintColor: Constants.black,
        fontFamily: 'Poppins',
      ),
      home: const IdentificationView(),
    );
  }
}