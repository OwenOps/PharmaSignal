import 'package:flutter/material.dart';

class MyCustomForm2 extends StatefulWidget {
  final String nom;
  final Function(int) quantiteRecu;
  final String quantiteV;
  final String quantiteR;

  const MyCustomForm2({
    super.key,
    required this.nom,
    required this.quantiteV,
    required this.quantiteR,
    required this.quantiteRecu,
  });

  @override
  _MyCustomForm2State createState() => _MyCustomForm2State();
}

class _MyCustomForm2State extends State<MyCustomForm2> {
  int? selectedValue;

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
                      initialValue: widget.nom,
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
              const SizedBox(height: 20), // Espace entre les champs de texte
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
                      initialValue: widget.quantiteV,
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
              const SizedBox(height: 20), // Espace entre les champs de texte
              Row(
                children: [
                  const Text(
                    'Quantité reçue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<int>(
                    value: int.parse(widget.quantiteR),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                      if (newValue != null) {
                        widget.quantiteRecu(newValue); // Appel du callback
                      }
                    },
                    items: List.generate(
                      int.tryParse(widget.quantiteV)!,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: selectedValue == index + 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return List.generate(
                        int.parse(widget.quantiteV),
                        (index) {
                          return Text(
                            (selectedValue ?? int.parse(widget.quantiteR))
                                .toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}