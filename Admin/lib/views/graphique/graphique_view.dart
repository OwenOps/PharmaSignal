import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/drop_down.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'medication_chart.dart';
import 'pharmacy_chart.dart'; 
import 'status_chart.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedValue = "Au cours de la dernière semaine";

  List<String> options = [
    'Au cours de la dernière semaine',
    'Au cours du dernier mois',
    'Au cours des 6 derniers mois',
    'Au cours de la dernière année'
  ];

  void changeValueDropDown(String? newValue) {
    setState(() {
      selectedValue = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.adminDarkBlue,
      body: ListView(
        children: [
          const LogoContainer(),
          Container(
            alignment: Alignment.center,
            child: DefaultDropDown(
              color: Constants.white,
              options: options,
              selectedOption: selectedValue,
              onChanged: changeValueDropDown,
            ),
          ),
          const SizedBox(height: 30),
          MedicationChart(period: selectedValue), // Utiliser le widget MedicationChart
          const SizedBox(height: 30),
          PharmacyChart(period: selectedValue), // Utiliser le widget PharmacyChart
          const SizedBox(height: 30),
          StatusChart(period: selectedValue), // Utiliser le widget StatusChart
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: SvgPicture.asset('assets/img/logo/logo.svg', height: MediaQuery.of(context).size.height * 2,),
        
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final List<String> options;

  const FilterBar({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fond blanc
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          underline: Container(),
          icon: const Icon(
              Icons.arrow_drop_down), // Aligner la flèche tout à droite
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(value.trim()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
