import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:provider/provider.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: provider.locale,
          icon: const Icon(Icons.language, color: Colors.blue),
          items: const [
            DropdownMenuItem(
              value: Locale('ar'),
              child: Text('Arabic'),
            ),
            DropdownMenuItem(
              value: Locale('de'),
              child: Text('German'),
            ),
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: Locale('es'),
              child: Text('Spanish'),
            ),
            DropdownMenuItem(
              value: Locale('zh'),
              child: Text('普通话'),
            ),
            DropdownMenuItem(
              value: Locale('fr'),
              child: Text('Français'),
            ),
          ],
          onChanged: (Locale? locale) {
            if (locale != null) {
              provider.setLocale(locale);
            }
          },
          style: const TextStyle(color: Colors.black, fontSize: 16),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
