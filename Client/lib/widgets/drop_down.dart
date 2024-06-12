import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/tiltle_text.dart';

class DefaultDropDown extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final String titleDropdown;
  final void Function(String?) onChanged;

  const DefaultDropDown({
    super.key,
    required this.options,
    required this.titleDropdown,
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
                width: 350,
                child: DropdownButtonFormField<String>(
                  value: selectedOption.isNotEmpty &&
                          options.contains(selectedOption)
                      ? selectedOption
                      : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0, color: Constants.darkBlue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onChanged,
                  items: options.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: 250,
                        child: Text(value ?? '', overflow: TextOverflow.ellipsis))
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
