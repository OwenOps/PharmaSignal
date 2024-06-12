import 'package:flutter/material.dart';
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/navigation_bar.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanData extends StatefulWidget {
  const ScanData({super.key, this.title});
  final String? title;

  @override
  State<ScanData> createState() => _ScanDataState();
}

class _ScanDataState extends State<ScanData> {
  late final ImagePicker _picker;
  late final DCVBarcodeReader _barcodeReader;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    _sdkInit();
  }

  @override
  void dispose() {
    super.dispose();
    _barcodeReader.stopScanning();
  }

  Future<void> _sdkInit() async {
    _barcodeReader = await DCVBarcodeReader.createInstance();
    _updateRuntimeSettings();
  }

  Future<void> _updateRuntimeSettings() async {
    DBRRuntimeSettings currentSettings =
        await _barcodeReader.getRuntimeSettings();
    currentSettings.barcodeFormatIds = EnumBarcodeFormat.BF_DATAMATRIX;
    currentSettings.expectedBarcodeCount = 1;
    await _barcodeReader.updateRuntimeSettings(currentSettings);
    await _barcodeReader.updateRuntimeSettingsFromTemplate(
        EnumDBRPresetTemplate.IMAGE_READ_RATE_FIRST);
    await _barcodeReader.enableResultVerification(true);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BarcodeScanner(),
    );
  }
}

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with WidgetsBindingObserver {
  late final DCVCameraEnhancer _cameraEnhancer;
  late final DCVBarcodeReader _barcodeReader;

  final DCVCameraView _cameraView = DCVCameraView();

  List<BarcodeResult> decodeRes = [];
  bool faceLens = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sdkInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraEnhancer.close();
    _barcodeReader.stopScanning();
    super.dispose();
  }

  void _sdkInit() async {
    _barcodeReader = await DCVBarcodeReader.createInstance();
    _cameraEnhancer = await DCVCameraEnhancer.createInstance();

    DBRRuntimeSettings currentSettings =
        await _barcodeReader.getRuntimeSettings();
    currentSettings.barcodeFormatIds = EnumBarcodeFormat.BF_DATAMATRIX;

    currentSettings.expectedBarcodeCount = 0;
    await _barcodeReader
        .updateRuntimeSettingsFromTemplate(EnumDBRPresetTemplate.DEFAULT);
    await _barcodeReader.updateRuntimeSettings(currentSettings);

    _cameraEnhancer.setScanRegion(Region(
        regionTop: 30,
        regionLeft: 15,
        regionBottom: 70,
        regionRight: 85,
        regionMeasuredByPercentage: 1));

    _cameraView.overlayVisible = true;

    _cameraView.torchButton = TorchButton(
      visible: true,
    );

    await _cameraEnhancer.open();

    _barcodeReader.startScanning();
    await _barcodeReader.enableResultVerification(true);

    _barcodeReader.receiveResultStream().listen((List<BarcodeResult>? res) {
      if (mounted) {
        if (res != null && res.isNotEmpty) {
          _vibrateWithBeep(); //faire un son de vibration

          String barcodeText = res.first.barcodeText;
          String searchString = "3400";
          int length = 13;

          int startIndex = barcodeText.indexOf(searchString);

          if (startIndex != -1 && barcodeText.length >= startIndex + length) {
            String truncatedText =
                barcodeText.substring(startIndex, startIndex + length); //tronquer de 3400 à "3400" + 9
            Data.dataValue = truncatedText;
            print(truncatedText);
          } else {
            print('Ce n\'est pas un code CIP');
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UserNavigationBar(),
            ),
          );

          _barcodeReader.stopScanning();
        }
        setState(() {
          decodeRes = res ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.scanYourMedicine ?? Constants.notAvailable),
        ),
        body: Stack(
          children: [
            Container(
              child: _cameraView,
            ),
            Positioned(
              top: 150,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  faceLens = !faceLens;
                  _cameraEnhancer.selectCamera(faceLens
                      ? EnumCameraPosition.CP_FRONT
                      : EnumCameraPosition.CP_BACK);
                },
                child: Image.asset(
                  'assets/img/scan/toggle_lens.png',
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ],
        ));
  }

  Widget listItem(BuildContext context, int index) {
    BarcodeResult res = decodeRes[index];

    return ListTileTheme(
        textColor: Colors.white,
        child: ListTile(
          title: Text(res.barcodeFormatString),
          subtitle: Text(res.barcodeText),
        ));
  }

  void _vibrateWithBeep() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
    FlutterBeep.beep();
  }
}
