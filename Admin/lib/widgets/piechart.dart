import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; //graphes pie

class MyPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final List<Color> colors;

  const MyPieChart({super.key, required this.medications, required this.colors});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _buildSections(),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    List<PieChartSectionData> sections = [];

    for (int i = 0; i < medications.length; i++) {
      Map<String, dynamic> med = medications[i];
      Color color = i < colors.length
          ? colors[i]
          : Colors
              .grey; // Utiliser une couleur grise par défaut si pas assez de couleurs fournies

      sections.add(
        PieChartSectionData(
          color: color,
          value: med['count']
              .toDouble(), // Utilisez le nombre de signalements pour la valeur de la section
          title: ' ',
          radius: 100,
        ),
      );
    }

    return sections;
  }
}

