import 'package:flutter/material.dart';
import 'package:pharma_signal/models/user.dart';
import 'package:pharma_signal/services/user_service.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_signal/utils/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportUserList extends StatelessWidget {
  const ReportUserList({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();

    return StreamBuilder<AppUser?>(
      stream: userService.getUserWithReportsStream(Data.user_uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Constants.darkBlue));
        }

        if (snapshot.hasError) {
          return Center(child: Text(AppLocalizations.of(context)?.errorHappened ?? Constants.notAvailable));
        }

        final user = snapshot.data!;
        final signalements = user.signalement;

        if (signalements == null || signalements.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)?.noDrugsFound ?? Constants.notAvailable));
        }
        // avoir les signalement "En cours" et en récup 10
        final enCoursSignalements = signalements
            .where((signalement) =>
                signalement.statut == StatusConstant.inProgress ||
                signalement.statut == StatusConstant.reported)
            .take(10)
            .toList();

        if (enCoursSignalements.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)?.noDrugsInProgress ?? Constants.notAvailable));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: enCoursSignalements.length,
          itemBuilder: (context, index) {
            final signalement = enCoursSignalements[index];
            return ListTile(
              minVerticalPadding: 20,
              title: Text(
                  '${signalement.denomination!.split(' ').take(4).join(' ')} '),
              leading: StreamBuilder<bool>(
                stream: checkImageStatus(signalement.image.toString()),
                builder: (context, snapshot) {
                  final bool isImageValid = snapshot.data ?? false;

                  // Vérifie si une image est disponible
                  Widget leadingWidget;
                  if (signalement.image!.isNotEmpty &&
                      Uri.parse(signalement.image.toString()).isAbsolute &&
                      isImageValid) {
                    leadingWidget = Image.network(
                      signalement.image!,
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
              subtitle: WidgetFunction.getStatusWidget(context, signalement.statut.toString())
            );
          },
        );
      },
    );
  }

  // Fonction pour vérifier le statut de l'URL de l'image
  Stream<bool> checkImageStatus(String url) async* {
    try {
      final response = await http.head(Uri.parse(url));
      yield response.statusCode == 200;
    } catch (e) {
      yield false;
    }
  }
}
