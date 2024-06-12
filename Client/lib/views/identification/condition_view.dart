import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConditionView extends StatelessWidget {
  const ConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                AppLocalizations.of(context)?.appUsageTitle ?? ''),
            _buildSubSectionTitle(
                AppLocalizations.of(context)?.residentsSubtitle ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.reportMedsParagraph ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.secureLoginParagraph ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.pharmacyListParagraph ?? ''),
            _buildSectionTitle(
                AppLocalizations.of(context)?.dataCollectionTitle ?? ''),
            _buildSubSectionTitle(
                AppLocalizations.of(context)?.dataCollectedSubtitle ?? ''),
            _buildBulletPoints(
                [AppLocalizations.of(context)?.dataCollectedBulletPoints ?? '']),
            _buildSubSectionTitle(
                AppLocalizations.of(context)?.dataUsageSubtitle ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.dataUsageParagraph ?? ''),
            _buildSectionTitle(
                AppLocalizations.of(context)?.dataSecurityTitle ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.dataSecurityParagraph ?? ''),
            _buildSectionTitle(
                AppLocalizations.of(context)?.userRightsTitle ?? ''),
            _buildSubSectionTitle(
                AppLocalizations.of(context)?.userRightsSubtitle ?? ''),
            _buildBulletPoints(
                [AppLocalizations.of(context)?.userRightsBulletPoints ?? '']),
            _buildParagraph(
                AppLocalizations.of(context)?.exerciseRightsParagraph ?? ''),
            _buildEmailLink(AppLocalizations.of(context)?.adminEmail ?? ''),
            _buildSectionTitle(
                AppLocalizations.of(context)?.termsModificationTitle ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.termsModificationParagraph ?? ''),
            _buildSectionTitle(
                AppLocalizations.of(context)?.contactTitle ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.contactParagraph ?? ''),
            _buildEmailLink(AppLocalizations.of(context)?.adminEmail ?? ''),
            _buildParagraph(
                AppLocalizations.of(context)?.appUsageAcceptance ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('• $point', style: const TextStyle(fontSize: 16)),
              ))
          .toList(),
    );
  }

  Widget _buildEmailLink(String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        email,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 16,
        ),
      ),
    );
  }
}
