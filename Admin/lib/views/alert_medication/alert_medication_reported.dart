import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_view.dart';
import 'package:mobile_application/widgets/button.dart';

class MedicationList1 extends StatelessWidget {
  const MedicationList1({super.key});

  Stream<List<Map<String, dynamic>>> streamMeds() {
    return FirebaseFirestore.instance
        .collection('admin_signalement')
        .where('Statut', isEqualTo: 'Signalé')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id; // Ajouter l'ID du document aux données
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Ajout du SingleChildScrollView
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: streamMeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Pas de signalement trouvé',
                    style: TextStyle(color: Constants.white)));
          } else {
            return ListView.builder(
              shrinkWrap:
                  true, // S'assure que la ListView prend seulement l'espace nécessaire
              physics:
                  const NeverScrollableScrollPhysics(), // Désactiver le défilement de la ListView
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var medication = snapshot.data![index];
                return Column(
                  children: [
                    Box1(medication: medication),
                    const SizedBox(height: 20),
                    const TraitSeparation(),
                    const SizedBox(height: 20),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Box1 extends StatelessWidget {
  final Map<String, dynamic> medication;

  const Box1({super.key, required this.medication});

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
                const SizedBox(height: 6),
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
              displayButtonSheet(
                  context,
                  medication['id'],
                  medication['Dénomination'],
                  (medication['QuantiteVoulue'].toString()),
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
              'Commander',
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

Future<void> displayButtonSheet(BuildContext context, String documentId,
    String nom, String quantite, String uidUser, String idSignalement) async {
  double screenHeight = MediaQuery.of(context).size.height;
  double targetHeight = screenHeight * 1.2 / 3;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: targetHeight,
        decoration: const BoxDecoration(
          color: Constants.adminDarkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomSheetContent(
          validerEtFermer: (context) =>
              validerEtFermer(context, documentId, uidUser, idSignalement),
          nom: nom,
          quantite: quantite.toString(),
        ),
      );
    },
  );
}

class BottomSheetContent extends StatefulWidget {
  final Function(BuildContext) validerEtFermer;
  final String nom;
  final String quantite;

  const BottomSheetContent(
      {super.key,
      required this.validerEtFermer,
      required this.nom,
      required this.quantite});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  bool isExpanded = false;
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
              'Approvisionnement',
              style: TextStyle(
                color: Constants.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MyCustomForm(nom: widget.nom, quantite: widget.quantite),
          BlueButton(
            onPressed: () => widget.validerEtFermer(context),
            description: "Traiter le signalement",
          ),
        ],
      ),
    );
  }
}
