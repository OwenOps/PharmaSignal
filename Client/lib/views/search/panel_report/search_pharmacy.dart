import 'package:flutter/material.dart';
import 'package:pharma_signal/models/location.dart';
import 'package:pharma_signal/services/location_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/drop_down.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPharmacy extends StatefulWidget {
  const SearchPharmacy({super.key});

  @override
  State<SearchPharmacy> createState() => _SearchPharmacyState();
}

class _SearchPharmacyState extends State<SearchPharmacy> {
  final codePostalController = TextEditingController();
  final ValueNotifier<int?> codePostalNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    configNotifier();
  }

  void configNotifier() {
    codePostalController.addListener(() {
      final text = codePostalController.text;
      if (text.isNotEmpty) {
        codePostalNotifier.value = int.parse(text);
      } else {
        codePostalNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    codePostalController.dispose();
    codePostalNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputNumberBase(
          description: AppLocalizations.of(context)?.postalCode ?? Constants.notAvailable,
          controller: codePostalController,
        ),
        ValueListenableBuilder<int?>(
          valueListenable: codePostalNotifier,
          builder: (context, codePostal, child) {
            return MenuDeroulantVillePharmacy(codePostal: codePostal ?? 0);
          },
        ),
      ],
    );
  }
}

class MenuDeroulantVillePharmacy extends StatefulWidget {
  final int codePostal;

  const MenuDeroulantVillePharmacy({super.key, required this.codePostal});

  @override
  _MenuDeroulantVillePharmacyState createState() =>
      _MenuDeroulantVillePharmacyState();
}

class _MenuDeroulantVillePharmacyState
    extends State<MenuDeroulantVillePharmacy> {
  String? selectedCity = '';
  String? selectedPharmacy = '';
  List<String> lstPharmacies = [];
  List<Location> lstCities = [];
  final LocationService locationService = LocationService();

  void changeCityDropDown(String? newValue) {
    setState(() {
      selectedCity = newValue;
      updatePharmacieList();
    });
  }

  void changePharmacieDropDown(String? newValue) {
    setState(() {
      selectedPharmacy = newValue;

      var tmp = lstCities.where((element) => element.pharmacy == newValue);

      if (tmp.isNotEmpty) {
        SignalementMedic.idPharmacy = tmp.first.id.toString();
      }

    });
  }

  void updatePharmacieList() {
    if (selectedCity != null) {
      var pharmacies = lstCities
          .where((element) => element.city == selectedCity)
          .map((e) => e.pharmacy)
          .where((pharmacy) => pharmacy != null)
          .cast<String>()
          .toSet()
          .toList();

      lstPharmacies =
          pharmacies.isNotEmpty ? pharmacies : [AppLocalizations.of(context)?.noPharmacy ?? Constants.notAvailable];
    } else {
      lstPharmacies = [];
    }
    selectedPharmacy = null;
  }

  List<String> setVille() {
    return lstCities
        .map((location) => location.city)
        .where((city) => city != null)
        .cast<String>()
        .toSet()
        .toList();
  }

  void resetWhenChangeCity() {
    selectedPharmacy = '';
    lstPharmacies = [];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Location>>(
        stream: locationService
            .getAllWithFilterCpS(widget.codePostal.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context)?.errorHappened ?? Constants.notAvailable));
          }
    
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            resetWhenChangeCity();
            return const DropDownNoData();
          }
    
          lstCities = snapshot.data!;
          List<String> cities = setVille();
    
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              children: [
                DefaultDropDown(
                    options: cities,
                    titleDropdown: AppLocalizations.of(context)?.city ?? Constants.notAvailable,
                    selectedOption: selectedCity ?? '',
                    onChanged: changeCityDropDown),
                const SizedBox(height: 30),
                DefaultDropDown(
                    options: lstPharmacies,
                    titleDropdown: AppLocalizations.of(context)?.pharmacy ?? Constants.notAvailable,
                    selectedOption: selectedPharmacy ?? '',
                    onChanged: changePharmacieDropDown)
              ],
            ),
          );
        });
  }
}

class DropDownNoData extends StatelessWidget {
  const DropDownNoData({super.key});

  void changeCityDropDown(String? newValue) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: DefaultDropDown(
          options: [AppLocalizations.of(context)?.noCity ?? Constants.notAvailable],
          titleDropdown: AppLocalizations.of(context)?.city ?? Constants.notAvailable,
          selectedOption: AppLocalizations.of(context)?.noCity ?? Constants.notAvailable,
          onChanged: changeCityDropDown,
        ));
  }
}