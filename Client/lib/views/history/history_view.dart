import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/img/logo/logo.svg',
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20),
            child: Text(
              AppLocalizations.of(context)?.myHistory ?? Constants.notAvailable,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  text: AppLocalizations.of(context)?.all ??
                      Constants.notAvailable,
                  icon: const Icon(
                    Icons.all_inbox,
                    size: 32,
                    color: Colors.grey,
                  )),
              Tab(
                  text: AppLocalizations.of(context)?.completed ??
                      Constants.notAvailable,
                  icon: const Icon(
                    Icons.check,
                    size: 32,
                    color: Colors.grey,
                  ))
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildToutTab(),
                _buildTermineeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToutTab() {
    UserService userService = UserService();
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Constants.white,
            child: StreamBuilder<AppUser?>(
              stream: userService.getUserWithReportsStream(Data.user_uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Constants.darkBlue));
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(AppLocalizations.of(context)?.errorHappened ??
                          Constants.notAvailable));
                }

                final user = snapshot.data!;
                final medicaments = user
                    .signalement; // Supposons que la structure du modèle d'utilisateur ait une liste de médicaments

                if (medicaments == null || medicaments.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context)?.noDrugsFound ??
                          Constants.notAvailable));
                }

                return ListView.builder(
                  itemCount: medicaments.length,
                  itemBuilder: (context, index) {
                    final medicament = medicaments[index];
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 30),
                      leading: FutureBuilder<bool>(
                        future: checkImageStatus(medicament.image.toString()),
                        builder: (context, snapshot) {
                          final bool isImageValid = snapshot.data ?? false;

                          // Vérifie si une image est disponible
                          Widget leadingWidget;
                          if (medicament.image!.isNotEmpty &&
                              Uri.parse(medicament.image.toString())
                                  .isAbsolute &&
                              isImageValid) {
                            leadingWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                medicament.image!,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            // Si pas d'image disponible, affiche un logo générique
                            leadingWidget = Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 32,
                                color: StatusConstant.otherColor,
                              ),
                            );
                          }

                          return leadingWidget;
                        },
                      ),
                      title: Text(
                        medicament.denomination!
                            .toString()
                            .split(' ')
                            .take(4)
                            .join(' '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          WidgetFunction.getStatusWidget(
                              context, medicament.statut.toString()),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermineeTab() {
    UserService userService = UserService();
    return Container(
      color: Constants.white,
      child: StreamBuilder<AppUser?>(
        stream: userService.getUserWithReportsStream(Data.user_uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Constants.darkBlue));
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Text(AppLocalizations.of(context)?.errorHappened ??
                    Constants.notAvailable));
          }

          final user = snapshot.data!;
          final medicaments = user.signalement;

          if (medicaments == null || medicaments.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)?.didntReportMeds ??
                    Constants.notAvailable));
          }

          final traiteMedicaments = medicaments
              .where((medicament) =>
                  medicament.statut == StatusConstant.terminated)
              .toList();

          if (traiteMedicaments.isEmpty) {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 45),
                child: Center(
                    child: Text(
                        AppLocalizations.of(context)?.noDrugsYouReportDidnt ??
                            Constants.notAvailable,
                        style: const TextStyle(fontSize: 16))));
          }
          return ListView.builder(
            itemCount: traiteMedicaments.length,
            itemBuilder: (context, index) {
              final medicament = traiteMedicaments[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                leading: FutureBuilder<bool>(
                  future: checkImageStatus(medicament.image.toString()),
                  builder: (context, snapshot) {
                    final bool isImageValid = snapshot.data ?? false;

                    Widget leadingWidget;
                    if (medicament.image!.isNotEmpty &&
                        Uri.parse(medicament.image.toString()).isAbsolute &&
                        isImageValid) {
                      leadingWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          medicament.image!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      leadingWidget = Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 32,
                          color: StatusConstant.otherColor,
                        ),
                      );
                    }
                    return leadingWidget;
                  },
                ),
                title: Text(
                  medicament.denomination.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    WidgetFunction.getStatusWidget(
                        context, medicament.statut.toString()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Fonction pour vérifier le statut de l'URL de l'image
Future<bool> checkImageStatus(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
