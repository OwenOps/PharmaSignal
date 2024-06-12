import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_custom_form.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_view.dart';

import '../../widgets/button.dart';

class MedicationList2 extends StatelessWidget {
  const MedicationList2({super.key});

  Stream<List<Map<String, dynamic>>> streamMeds() {
    return FirebaseFirestore.instance
        .collection('admin_signalement')
        .where('Statut', isEqualTo: 'En Cours')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id; // Ajouter l'ID du document aux données
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: streamMeds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Pas de signalement en cours',
                  style: TextStyle(color: Constants.white)));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var medication = snapshot.data![index];
              return Column(
                children: [
                  Box2(medication: medication),
                  const SizedBox(height: 20),
                  const TraitSeparation(),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class Box2 extends StatelessWidget {
  final Map<String, dynamic> medication;

  const Box2({super.key, required this.medication});

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication['Dénomination'] ?? 'No name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Signalé le : ${formatDate(medication['DateSignalement'])}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Afficher le bouton sous forme de feuille inférieure
              displayButtonSheet2(
                  context,
                  medication['id'],
                  medication['Dénomination'],
                  (medication['QuantiteVoulue'].toString()),
                  (medication['QuantiteRecue'].toString()),
                  medication['UID_User'],
                  medication['IdSignalement']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Informations',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> displayButtonSheet2(
    BuildContext context,
    String documentId,
    String nom,
    String QuantiteVoulue,
    String QuantiteRecue,
    String uidUser,
    String idSignalement) async {
  // Récupération de la hauteur de l'écran et calcul de la hauteur cible pour la feuille inférieure
  double screenHeight = MediaQuery.of(context).size.height;
  double targetHeight = screenHeight * 1.4 / 3;

  // Affichage de la feuille inférieure en tant que modal
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      // Construction de la feuille inférieure avec une hauteur cible et un contenu
      return Container(
        height: targetHeight,
        decoration: const BoxDecoration(
          color: Constants.adminDarkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomSheetContent2(
          validerEtFermer: (context, selectedValue) => validerEtFermer2(
              context,
              documentId,
              selectedValue,
              int.parse(QuantiteVoulue),
              uidUser,
              idSignalement),
          nom: nom,
          quantiteV: QuantiteVoulue.toString(),
          quantiteR: QuantiteRecue.toString(),
        ),
      );
    },
  );
}

class BottomSheetContent2 extends StatefulWidget {
  final Function(BuildContext, int) validerEtFermer;
  final String nom;
  final String quantiteV;
  final String quantiteR;

  const BottomSheetContent2(
      {super.key,
      required this.validerEtFermer,
      required this.nom,
      required this.quantiteV,
      required this.quantiteR});
  @override
  _BottomSheetContentState2 createState() => _BottomSheetContentState2();
}

class _BottomSheetContentState2 extends State<BottomSheetContent2> {
  bool isExpanded = false;
  int? selectedValue;
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
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              'Information Commande',
              style: TextStyle(
                color: Constants.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Liste déroulante des informations sur le médicament
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                this.isExpanded = !this.isExpanded;
              });
            },
          ),
          MyCustomForm2(
            nom: widget.nom,
            quantiteV: widget.quantiteV,
            quantiteR: widget.quantiteR,
            quantiteRecu: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
          BlueButton(
              onPressed: () {
                widget.validerEtFermer(context, selectedValue!);
              },
              description:
                  "Actualiser / Clôturer le signalement"), // Bouton bleu pour valider et fermer la feuille inférieure
        ],
      ),
    );
  }
}

void validerEtFermer2(
    BuildContext context,
    String documentId,
    int selectedValue,
    int QuantiteVoulue,
    String uidUser,
    String idSignalement) async {
  if (selectedValue != QuantiteVoulue) {
    await FirebaseFirestore.instance
        .collection('admin_signalement')
        .doc(documentId)
        .update({'QuantiteRecue': selectedValue});

    // Fermer la pop-up
    Navigator.of(context).pop();
  } else {
    // Fermer la pop-up
    Navigator.of(context).pop();
    // Mise à jour du statut du signalement dans Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference adminSignalementRef =
        firestore.collection('admin_signalement').doc(documentId);
    await adminSignalementRef.update({
      'Statut': 'Terminé',
      'QuantiteRecue': selectedValue,
      "DateTraitement": Timestamp.now()
    });

    DocumentReference userRef =
        firestore.collection('utilisateurs').doc(uidUser);
    DocumentReference signalementRef =
        userRef.collection('signalements').doc(idSignalement);

    await signalementRef.update({'Statut': 'Clôturé'});
  }
}
