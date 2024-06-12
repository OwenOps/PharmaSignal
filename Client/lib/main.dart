import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/identification/check_authentification.dart';
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AppInitializer().initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'PharmaSignal',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Constants.darkBlue,
              hintColor: Constants.black,
              fontFamily: 'Poppins',
            ),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('es'),
              Locale('de'),
              Locale('ar'),
              Locale('zh')
            ],
            home: const AuthChecker(),
          );
        },
      ),
    );
  }
}

class AppInitializer {
  Future<void> initializeApp() async {
    try {
      await DCVBarcodeReader.initLicense(dotenv.env['SCAN_API_KEY']!);
    } catch (e) {
      print(e);
    }
  }
}
