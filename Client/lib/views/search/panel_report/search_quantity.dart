import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchQuantity extends StatefulWidget {
  const SearchQuantity({super.key});

  @override
  _SearchQuantityState createState() => _SearchQuantityState();
}

class _SearchQuantityState extends State<SearchQuantity> {
  int? selectedQuantity = 1;
  bool showCustomQuantityBox = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedQuantity = 1;
    SignalementMedic.qteDemande = selectedQuantity;
    _controller.text = selectedQuantity.toString();
  }

  void updateCustomQuantityBox(String value) {
      setState(() {
                selectedQuantity = int.tryParse(value);
                SignalementMedic.qteDemande = int.tryParse(value);
              });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            AppLocalizations.of(context)?.quantityNeeded ?? Constants.notAvailable,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              _buildQuantityBox(1),
              const SizedBox(width: 20),
              _buildQuantityBox(2),
              const SizedBox(width: 20),
              _buildQuantityBox(3),
              const SizedBox(width: 20),
              _buildPlusBox(),
            ],
          ),
        ),
        const SizedBox(height: 30),
        if (showCustomQuantityBox) _buildCustomQuantityBox(),
      ],
    );
  }

  Widget _buildQuantityBox(int quantity) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuantity = quantity;
          showCustomQuantityBox = false;
          _controller.text = selectedQuantity.toString();
          SignalementMedic.qteDemande = quantity;
        });
      },
      child: Container(
        width: 63,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 0.8, color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          color: selectedQuantity == quantity ? Colors.blue : Colors.white,
        ),
        child: Text(
          '$quantity',
          style: TextStyle(
            color: selectedQuantity == quantity ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPlusBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuantity = null;
          showCustomQuantityBox = true;
        });
      },
      child: Container(
        width: 50,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 0.8, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: selectedQuantity == null ? Colors.blue : Colors.white,
        ),
        child: Text(
          '+',
          style: TextStyle(
            color: selectedQuantity == null ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomQuantityBox() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 0),
        child: SizedBox(
          height: 80,
          width: 320,
          child: InputNumberBase(
            description: AppLocalizations.of(context)?.enterQuantityNeeded ?? Constants.notAvailable, 
            controller: _controller, 
            onChanged:(String value) => updateCustomQuantityBox(value))
        ),
      ),
    );
  }
}
