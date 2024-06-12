import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/tiltle_text.dart';

class DefaultDropDown extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final String titleDropdown;
  final Color color;
  final void Function(String?) onChanged;

  const DefaultDropDown({
    super.key,
    required this.options,
    this.color = Constants.adminDarkBlue,
    this.titleDropdown = "",
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(titleDropdown),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  value: selectedOption.isNotEmpty &&
                          options.contains(selectedOption)
                      ? selectedOption
                      : null,
                  decoration: InputDecoration(
                    fillColor: color, // Couleur de fond blanche
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.3, color: Colors.white), // Bordure blanche
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Constants.darkBlue), // Bordure quand focussé
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropdownColor: Colors.white, // Couleur de fond des options
                  style: const TextStyle(
                      color: Colors.black), // Style du texte des options
                  onChanged: onChanged,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            color: Colors.black), // Texte en noir
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
