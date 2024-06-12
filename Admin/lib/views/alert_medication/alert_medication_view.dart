import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_in_progress.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_reported.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_terminated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const AlertMedicationView());
}

class AlertMedicationView extends StatefulWidget {
  const AlertMedicationView({super.key});

  @override
  State<AlertMedicationView> createState() => _AlertMedicationViewState();
}

class _AlertMedicationViewState extends State<AlertMedicationView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constants.adminDarkBlue,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            LogoMedicament(),
            Expanded(child: MaivView()),
          ],
        ),
      ),
    );
  }
}

class LogoMedicament extends StatelessWidget {
  const LogoMedicament({Key? key});
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/img/logo/logo.svg',
      width: 200,
      height: 200,
    );
  }
}

class MaivView extends StatefulWidget {
  const MaivView({super.key});

  @override
  State<MaivView> createState() => _MaivViewState();
}

class _MaivViewState extends State<MaivView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.adminDarkBlue,
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  backgroundColor: Constants.darkBlue,
                  unselectedBackgroundColor: Constants.white,
                  unselectedBorderColor: Constants.darkBlue,
                  contentPadding: const EdgeInsets.only(left: 25, right: 25),
                  height: 35,
                  borderColor: Constants.darkBlue,
                  borderWidth: 2,
                  unselectedLabelStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(
                      text: "À traiter",
                    ),
                    Tab(
                      text: "En cours",
                    ),
                    Tab(
                      text: "Terminé",
                    ),
                  ],
                  buttonMargin: const EdgeInsets.only(right: 20, left: 20),
                ),
                const SizedBox(height: 40),
                const Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      MedicationList1(),
                      MedicationList2(), // Adjust as needed
                      MedicamentInfo3(), // Adjust as needed
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TraitSeparation extends StatelessWidget {
  const TraitSeparation({Key? key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: const Divider(
            height: 2,
            thickness: 0.5,
            indent: 35,
            endIndent: 35,
          ), // Ajout du trait séparateur
        ),
      ],
    );
  }
}

class MyCustomForm extends StatelessWidget {
  final String nom;
  final String quantite;

  const MyCustomForm({super.key, required this.nom, required this.quantite});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Nom',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      initialValue: nom,
                      style: const TextStyle(
                          color: Colors.white), // Texte en blanc
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      enabled: false, // Rendre le champ non modifiable
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espace entre les deux textes
              Row(
                children: [
                  const Text(
                    'Quantité demandée',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      initialValue: quantite,
                      style: const TextStyle(
                          color: Colors.white), // Texte en blanc
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      enabled: false, // Rendre le champ non modifiable
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

void validerEtFermer(BuildContext context, String documentId, String uidUser,
    String idSignalement) async {
  Navigator.of(context).pop();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference adminSignalementRef =
      firestore.collection('admin_signalement').doc(documentId);
  await adminSignalementRef.update({'Statut': 'En Cours'});

  DocumentReference userRef = firestore.collection('utilisateurs').doc(uidUser);
  DocumentReference signalementRef =
      userRef.collection('signalements').doc(idSignalement);

  await signalementRef.update({'Statut': 'En Cours'});
}