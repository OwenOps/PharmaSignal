import 'package:flutter/material.dart';
import 'package:pharma_signal/models/drugs.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/history/history_view.dart';
import 'package:pharma_signal/views/search/panel_report/search_panel_report.dart';
import 'package:pharma_signal/widgets/navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchingListMed extends StatefulWidget {
  List<Medicament?> searchResults;

  SearchingListMed({super.key, required this.searchResults});

  @override
  State<SearchingListMed> createState() => _SearchingListMedState();
}

class _SearchingListMedState extends State<SearchingListMed> {
  Future<void> displayButtonSheet(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double targetHeight = screenHeight * 3 / 4;

    // Affichage de la feuille inférieure en tant que modal
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Construction de la feuille inférieure avec une hauteur cible et un contenu
        return Container(
          height: targetHeight,
          decoration: const BoxDecoration(
            color: Constants.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SearchPanelReport(validerEtFermer: validerEtFermer),
        );
      },
    );
  }

  void validerEtFermer(BuildContext context) async {
    // Fermer la pop-up

    // Créer le rapport
    await WidgetFunction.createReport(context);

    // Afficher une pop-up indiquant que le signalement a été effectué avec succès
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.reportAMedicine ?? Constants.notAvailable),
          content: Text(
            "${AppLocalizations.of(context)?.thanks ?? Constants.notAvailable} ${Data.user?.lastName ?? ''}! ${AppLocalizations.of(context)?.yourReportHasBeenSend ?? Constants.notAvailable}",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserNavigationBar(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  setReport(MedicamentWithId medicament) {
    SignalementMedic.denomination = medicament.denomination;
    SignalementMedic.forme = medicament.forme;
    SignalementMedic.marque = medicament.marque;
    SignalementMedic.image = medicament.image;
    SignalementMedic.voieAdmin = medicament.voiesAdministration;
    SignalementMedic.id = medicament.id;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.searchResults.isEmpty ? Text(
              AppLocalizations.of(context)?.noDrugsFound ?? Constants.notAvailable,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          : Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.20),
              child: ListView.builder(
                itemCount: widget.searchResults.length,
                itemBuilder: (context, index) {
                  final medicament =
                      widget.searchResults[index] as MedicamentWithId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: FutureBuilder<bool>(
                        future: checkImageStatus(medicament.image),
                        builder: (context, snapshot) {
                          final bool isImageValid = snapshot.data ?? false;
                          // Vérifie si une image est disponible
                          Widget leadingWidget;
                          if (medicament.image.isNotEmpty &&
                              Uri.parse(medicament.image).isAbsolute &&
                              isImageValid) {
                            leadingWidget = Image.network(
                              medicament.image,
                              width: 75,
                              height: 55,
                              fit: BoxFit.cover,
                            );
                          } else {
                            // Si pas d'image disponible, affiche un logo générique
                            leadingWidget = Container(
                              width: 75,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return leadingWidget;
                        },
                      ),
                      title: medicament.denomination.isNotEmpty
                          ? Text(
                              '${medicament.denomination.split(' ').take(2).join(' ')}...') //prendre les deux premiers mots du médicament
                          : const Text(''),
                      trailing: ElevatedButton(
                        //BOUTON SIGNALEMENT ouvrir widget de damien
                        onPressed: () {
                          setReport(medicament);
                          displayButtonSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: Text(
                          AppLocalizations.of(context)?.report ?? Constants.notAvailable,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
