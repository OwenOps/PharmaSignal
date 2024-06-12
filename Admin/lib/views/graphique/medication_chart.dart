import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/piechart.dart';

class MedicationChart extends StatelessWidget {
  final String period;

  const MedicationChart({super.key, required this.period});

  Future<List<Map<String, dynamic>>> fetchMedications(String period) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('admin_signalement')
        .where('DateSignalement', isGreaterThan: _getDateFromPeriod(period))
        .get();

    // Agrégation des médicaments par CodeCIP
    Map<String, Map<String, dynamic>> medicationCounts = {};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String codeCIP = data['CodeCIP'];
      if (medicationCounts.containsKey(codeCIP)) {
        medicationCounts[codeCIP]!['count'] += 1;
      } else {
        medicationCounts[codeCIP] = {
          'CodeCIP': codeCIP,
          'Dénomination': data['Dénomination'],
          'count': 1,
        };
      }
    }

    // Convertir en liste et trier par le count en ordre décroissant
    List<Map<String, dynamic>> medications = medicationCounts.values.toList();
    medications.sort((a, b) => b['count'].compareTo(a['count']));

    // Récupérer les trois premiers éléments
    return medications.take(5).toList();
  }

  DateTime _getDateFromPeriod(String period) {
    DateTime now = DateTime.now();
    switch (period) {
      case 'Au cours de la dernière semaine':
        return now.subtract(const Duration(days: 7));
      case 'Au cours du dernier mois':
        return DateTime(now.year, now.month - 1, now.day);
      case 'Au cours des 6 derniers mois':
        return DateTime(now.year, now.month - 6, now.day);
      case 'Au cours de la dernière année':
        return DateTime(now.year - 1, now.month, now.day);
      default:
        return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMedications(period),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des données'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Aucune donnée disponible'));
        } else {
          List<Map<String, dynamic>> medications = snapshot.data!;
          int totalSignalements =
              medications.fold<int>(0, (sum, med) => sum + med['count'] as int);

          // Définir les couleurs pour les trois médicaments
          List<Color> colors = [
            Constants.darkGrey,
            Constants.darkGreen,
            Constants.darkBlue,
            Colors.deepOrange,
            Colors.deepPurple
          ];

          return ChartContainer(
            title: 'Médicaments les plus signalés',
            chartWidget: MyPieChart(medications: medications, colors: colors),
            medications: medications.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> med = entry.value;
              double percentage = (med['count'] / totalSignalements) * 100;
              return MedicationItem(
                color: colors[index],
                name: med['Dénomination'] != null &&
                        med['Dénomination'].contains(' ')
                    ? med['Dénomination'].split(' ')[0]
                    : med['Dénomination'],
                percentage: '${percentage.toStringAsFixed(2)}%',
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class ChartContainer extends StatelessWidget {
  final String title;
  final Widget chartWidget;
  final List<Widget> medications;

  const ChartContainer({
    super.key,
    required this.title,
    required this.chartWidget,
    required this.medications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: 390,
      decoration: BoxDecoration(
        color: Constants.adminStatDarkBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                color: Constants.adminStatDarkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 200,
            color: Constants.adminStatDarkBlue,
            child: Center(child: chartWidget),
          ),
          const SizedBox(height: 15),
          Flexible(
              child: Container(
            decoration: BoxDecoration(
              color: Constants.adminStatDarkBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Scrollbar(
                thumbVisibility: true,
                thickness: 1.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runSpacing: 7.0,
                      children: medications,
                    ),
                  ),
                )),
          )),
        ],
      ),
    );
  }
}

class MedicationItem extends StatelessWidget {
  final Color color;
  final String name;
  final String percentage;

  const MedicationItem({
    super.key,
    required this.color,
    required this.name,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Center(
            child: Text(
              '$name\n$percentage',
              style: const TextStyle(
                color: Constants.white,
                fontSize: 13.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
