import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_application/utils/constants.dart';

class MedicamentInfo3 extends StatelessWidget {
  const MedicamentInfo3({super.key});

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 35), // Ajout du padding à gauche et à droite
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('admin_signalement')
                  .where('Statut', isEqualTo: 'Terminé')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Aucune donnée trouvée',
                          style: TextStyle(color: Constants.white)));
                }

                var documents = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap:
                      true, // S'assure que la ListView prend seulement l'espace nécessaire
                  physics:
                      const NeverScrollableScrollPhysics(), // Désactiver le défilement de la ListView
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    String nom = data['Dénomination'] ?? 'Nom inconnu';
                    String quantite = data['QuantiteVoulue']?.toString() ??
                        'Quantité non disponible';

                    String formattedDate = formatDate(data['DateTraitement']);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nom,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Signalé le : $formattedDate',
                                  style: const TextStyle(
                                    color: Constants.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Quantité  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constants.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        quantite,
                                        style: const TextStyle(
                                            color: Constants.white,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}