import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/barchart2.dart';

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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: medications,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChart extends StatelessWidget {
  final String period;

  const StatusChart({super.key, required this.period});

  Future<List<Map<String, dynamic>>> fetchStatusCounts(String period) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('admin_signalement')
        .where('DateSignalement', isGreaterThan: _getDateFromPeriod(period))
        .get();

    Map<String, int> statusCounts = {};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String status = data['Statut'] ?? 'Unknown'; // Provide a default value if null
      if (statusCounts.containsKey(status)) {
        statusCounts[status] = statusCounts[status]! + 1;
      } else {
        statusCounts[status] = 1;
      }
    }

    List<Map<String, dynamic>> statusList = statusCounts.entries.map((entry) {
      return {'Statut': entry.key, 'count': entry.value};
    }).toList();

    return statusList;
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchStatusCounts(period),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des données'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée disponible'));
        } else {
          List<Map<String, dynamic>> pharmacies = snapshot.data!;
          int totalSignalements = pharmacies.fold<int>(
              0, (sum, pharmacy) => sum + (pharmacy['count'] as int));

          List<Color> defaultColors = [
            Constants.darkGrey,
            Constants.darkGreen,
            Constants.darkBlue
          ];

          return ChartContainer(
            title: 'Statut des signalements',
            chartWidget: MyChartWidget2(
              title: '',
              pharmacies: pharmacies.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> pharmacy = entry.value;
                double percentage = (pharmacy['count'] / totalSignalements) * 100;
                return {
                  'name': pharmacy['Statut'],
                  'count': pharmacy['count'],
                  'percentage': percentage,
                  'color': defaultColors[index % defaultColors.length],
                };
              }).toList(),
              colors: defaultColors,
            ),
            medications: pharmacies.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> pharmacy = entry.value;
              double percentage = (pharmacy['count'] / totalSignalements) * 100;
              return MedicationItem(
                color: defaultColors[index % defaultColors.length],
                name: pharmacy['Statut'] as String,
                percentage: '${percentage.toStringAsFixed(2)}%',
              );
            }).toList(),
          );
        }
      },
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
