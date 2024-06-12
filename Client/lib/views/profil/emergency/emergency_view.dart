import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text(
                AppLocalizations.of(context)?.helpNumber ?? Constants.notAvailable,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    _UrgenceLine(
                      number: "15",
                      title: "Samu",
                      description: AppLocalizations.of(context)?.medicalUrgency ?? Constants.notAvailable,
                    ),
                    _UrgenceLine(
                      number: "17",
                      title: "Police",
                      description:
                          AppLocalizations.of(context)?.victim ?? Constants.notAvailable,
                    ),
                    _UrgenceLine(
                      number: "18",
                      title: "Pompiers",
                      description: AppLocalizations.of(context)?.perilousSituation ?? Constants.notAvailable,
                    ),
                    _UrgenceLine(
                      number: "112",
                      title: AppLocalizations.of(context)?.urgencyCall ?? Constants.notAvailable,
                      description:
                          AppLocalizations.of(context)?.europeenNumber ?? Constants.notAvailable,
                      lastLine: true,
                    ),
                    _UrgenceLine(
                      number: "114",
                      title: AppLocalizations.of(context)?.urgencySMS ?? Constants.notAvailable,
                      description:
                          AppLocalizations.of(context)?.handicap ?? Constants.notAvailable,
                      lastLine: true,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

//Quand un widget se repete, on peut en faire une classe pour se simplifier le vie.
class _UrgenceLine extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool lastLine;

  const _UrgenceLine({
    required this.number,
    required this.title,
    required this.description,
    this.lastLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        top: 30,
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.darkBlue,
            ),
            padding: EdgeInsets.all(lastLine ? 9.0 : 14.0),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 30,
                color: Constants.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                Text(description,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Constants.darkGrey))
              ],
            ),
          )
        ],
      ),
    );
  }
}
