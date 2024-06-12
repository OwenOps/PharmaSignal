import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/views/search/panel_report/search_pharmacy.dart';
import 'package:pharma_signal/views/search/panel_report/search_quantity.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPanelReport extends StatefulWidget {
  final Function(BuildContext) validerEtFermer;
  const SearchPanelReport({super.key, required this.validerEtFermer});

  @override
  _SearchPanelReportState createState() => _SearchPanelReportState();
}

class _SearchPanelReportState extends State<SearchPanelReport> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20), // Espace entre la barre et le haut
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              width: 120,
              height: 6,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              AppLocalizations.of(context)?.reportAMedicine ?? Constants.notAvailable,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ExpansionPanelWidget(),
          const SearchQuantity(),
          const SearchPharmacy(),
          const SizedBox(height: 25),
          BlueButton(
              onPressed: () => widget.validerEtFermer(context),
              description: AppLocalizations.of(context)?.validate ?? Constants.notAvailable),
          const SizedBox(height: 60)
        ],
      ),
    );
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  const ExpansionPanelWidget({super.key});

  @override
  State<ExpansionPanelWidget> createState() => _ExpansionPanelWidgetState();
}

class _ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  bool isExpanded = false;

  // Liste des widgets pour les informations sur le médicament
  final List<Widget> informationsMedicament = [
    InputTextBase(description: SignalementMedic.marque, enabled: false),
    InputTextBase(description: SignalementMedic.denomination, enabled: false),
    InputTextBase(description: SignalementMedic.forme, enabled: false),
    InputTextBase(description: SignalementMedic.voieAdmin, enabled: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 25, bottom: 25),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              this.isExpanded = !this.isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return InkWell(
                  onTap: () =>
                      setState(() => this.isExpanded = !this.isExpanded),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)?.infosAboutMedicine ?? Constants.notAvailable,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              body: Container(
                color: Colors.white,
                child: Column(
                  children: informationsMedicament,
                ),
              ),
              isExpanded: isExpanded,
            ),
          ],
        ));
  }
}
