import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/tiltle_text.dart';

//Input de base avec un label.
//Quand on clique dedans, le label va au dessus.
//Pour ca qu'il y a le boolean usePlaceholder pour changer ca.
class InputTextBase extends StatelessWidget {
  final String description;
  final TextEditingController? controller;
  final bool usePlaceholder;
  final String errorText;
  final bool enabled;

  const InputTextBase({
    super.key,
    required this.description,
    this.controller,
    this.enabled = true,
    this.errorText = "Le champ doit être complété.",
    this.usePlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: SizedBox(
        height: 80,
        width: 320,
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          style: TextStyle(fontSize: 18,
              color: enabled ? Colors.black : Colors.black),
          decoration: InputDecoration(
            labelText: usePlaceholder ? null : description,
            hintText: usePlaceholder ? description : null,
            labelStyle: TextStyle(color: enabled ? Constants.darkGrey : Colors.black),
            errorStyle: const TextStyle(color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            fillColor: enabled ? null : Constants.lightGrey,
            filled: !enabled,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0.8,
                  color: Constants.darkGrey),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0.8,
                  color: Constants.darkGrey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Constants.darkBlue),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
          ),
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) {
              return errorText;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class InputTextArea extends InputTextBase {
  const InputTextArea({
    super.key,
    required super.description,
    super.controller, required bool enabled,
  }) : super(
          usePlaceholder: true,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 150.0,
      padding: const EdgeInsets.only(top: 1.0, left: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        minLines: 1,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: description,
          hintStyle: const TextStyle(color: Constants.darkGrey),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return super.errorText;
          }
          return null;
        },
      ),
    );
  }
}

//pour les chiffres max 5
class InputNumberBase extends StatelessWidget {
  final String description;
  final TextEditingController? controller;
  final bool usePlaceholder;
  final String errorText;

  const InputNumberBase({
    super.key,
    required this.description,
    this.controller,
    this.errorText = "Le champ doit être complété.",
    this.usePlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: SizedBox(
        height: 80,
        width: 320,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 18),
          keyboardType: TextInputType.number, // Utiliser un clavier numérique
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5)
          ], // Limiter à 5 chiffres
          decoration: InputDecoration(
            labelText: usePlaceholder ? null : description,
            hintText: usePlaceholder ? description : null,
            labelStyle: const TextStyle(color: Constants.darkGrey),
            hintStyle: const TextStyle(color: Constants.darkGrey),
            errorStyle: const TextStyle(color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.8),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Constants.darkBlue),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
        ),
      ),
    );
  }
}

//Un bloc avec un titre et un input.
class InputTextTitle extends StatelessWidget {
  final String titleInput;
  final String description;
  final TextEditingController? controller;

  const InputTextTitle(
      {super.key,
      required this.titleInput,
      required this.description,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(titleInput),
        InputTextBase(
          description: description,
          usePlaceholder: true,
          controller: controller,
        ),
      ],
    );
  }
}

class InputTextWithEmailFormatValidator extends StatefulWidget {
  final String description;
  final String? height;
  final TextEditingController? controller;
  final Icon iconique;

  const InputTextWithEmailFormatValidator({
    super.key,
    required this.description,
    this.controller,
    this.height,
    required this.iconique,
  });

  @override
  _InputTextWithEmailFormatValidatorState createState() =>
      _InputTextWithEmailFormatValidatorState();
}

class _InputTextWithEmailFormatValidatorState
    extends State<InputTextWithEmailFormatValidator> {
  final TextEditingController _textController = TextEditingController();
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        height: 80,
        width: 350,
        child: TextFormField(
          controller: widget.controller ?? _textController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 13, color: Constants.white),
          decoration: InputDecoration(
            labelText: widget.description,
            labelStyle: const TextStyle(color: Constants.white),
            errorText: _isValid ? null : 'Veuillez saisir une adresse e-mail valide.',
            errorStyle: const TextStyle(color: Colors.red),
            suffixIcon: widget.iconique != null
                ? Icon(
                    widget.iconique.icon,
                    color: Constants.white, // Ici, on définit la couleur de l'icône en blanc
                  )
                : null,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.3, color: Constants.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Constants.white),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _isValid = EmailValidator.validate(value);
            });
          },
        ),
      ),
    );
  }
}

class InputTextWithVisibilityToggle extends StatefulWidget {
  final String description;
  final TextEditingController? controller;
  final Icon iconique;

  const InputTextWithVisibilityToggle({
    super.key,
    required this.description,
    this.controller,
    required this.iconique,
  });

  @override
  _InputTextWithVisibilityToggleState createState() => _InputTextWithVisibilityToggleState();
}

class _InputTextWithVisibilityToggleState extends State<InputTextWithVisibilityToggle> {
  bool _obscureText = true; // Variable pour contrôler la visibilité du texte

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        height: 60,
        width: 350,
        child: TextFormField(
          key: Key(widget.description), // Clé unique pour chaque champ de texte
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 13, color: Constants.white),
          decoration: InputDecoration(
            labelText: widget.description,
            labelStyle: const TextStyle(color: Constants.lightGrey),
            errorStyle: const TextStyle(color: Colors.red),
            //contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Constants.white,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText; // Basculer la visibilité du texte
                });
              },
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.3, color: Constants.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Constants.white),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Le champ doit être complété.";
            }
            return null;
          },
        ),
      ),
    );
  }
}
