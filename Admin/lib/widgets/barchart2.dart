import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

class MyChartWidget2 extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> pharmacies;
  final List<Color> colors;

  const MyChartWidget2({
    super.key,
    required this.title,
    required this.pharmacies,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    List<DChartBarDataCustom> listData = pharmacies.map((pharmacy) {
      return DChartBarDataCustom(
        value: (pharmacy['count'] as int).toDouble(), // Utilisez le nombre de signalements pour la valeur de la barre
        label: pharmacy['name'] as String, // Utilisez le nom de la pharmacie comme étiquette
        color: pharmacy['color'] as Color?, // Utilisez la couleur spécifiée pour la pharmacie
      );
    }).toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: DChartBarCustom(
            listData: listData,
          ),
        ),
      ],
    );
  }
}
