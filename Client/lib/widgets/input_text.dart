import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/tiltle_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    this.errorText = "",
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
          style: TextStyle(
              fontSize: 18, color: enabled ? Colors.black : Colors.black),
          decoration: InputDecoration(
            labelText: usePlaceholder ? null : description,
            hintText: usePlaceholder ? description : null,
            labelStyle:
                TextStyle(color: enabled ? Constants.darkGrey : Colors.black),
            errorStyle: const TextStyle(color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            fillColor: enabled ? null : Constants.lightGrey,
            filled: !enabled,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.8, color: Constants.darkGrey),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.8, color: Constants.darkGrey),
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
              return AppLocalizations.of(context)?.needToBeCompleted ?? Constants.notAvailable;
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
    super.controller,
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

class InputNumberBase extends StatefulWidget {
  final String description;
  final TextEditingController? controller;
  final String errorText;
  final void Function(String)? onChanged;

  const InputNumberBase({
    Key? key,
    required this.description,
    this.controller,
    this.errorText = "Le champ doit être complété.",
    this.onChanged,
  }) : super(key: key);

  @override
  _InputNumberBaseState createState() => _InputNumberBaseState();
}

class _InputNumberBaseState extends State<InputNumberBase> {
  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_checkShowClearButton);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_checkShowClearButton);
    super.dispose();
  }

  void _checkShowClearButton() {
    setState(() {
      showClearButton = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: SizedBox(
        height: 80,
        width: 320,
        child: Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              style: const TextStyle(fontSize: 18),
              keyboardType: TextInputType.number,
              onChanged: widget.onChanged,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                labelText: widget.description,
                labelStyle: const TextStyle(color: Constants.darkGrey),
                hintStyle: const TextStyle(color: Constants.darkGrey),
                errorStyle: const TextStyle(color: Colors.red),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2.0, color: Constants.darkBlue),
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
                  return widget.errorText;
                }
                return null;
              },
            ),
            if (showClearButton)
              Positioned(
                right: 0,
                top: 0,
                bottom: 30,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).unfocus(); //pr fermer la saisie
                      showClearButton = false;
                    });
                  },
                ),
              ),
          ],
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
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            labelText: widget.description,
            labelStyle: const TextStyle(color: Constants.darkGrey),
            errorText:
                _isValid ? null : AppLocalizations.of(context)?.chooseGoodEmail ?? Constants.notAvailable,
            errorStyle: const TextStyle(color: Colors.red),
            suffixIcon: widget.iconique,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.3),
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
  _InputTextWithVisibilityToggleState createState() =>
      _InputTextWithVisibilityToggleState();
}

class _InputTextWithVisibilityToggleState
    extends State<InputTextWithVisibilityToggle> {
  bool _obscureText = true; // Variable pour contrôler la visibilité du texte

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        height: 80,
        width: 350,
        child: TextFormField(
          key: Key(widget.description), // Clé unique pour chaque champ de texte
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            labelText: widget.description,
            labelStyle: const TextStyle(color: Constants.darkGrey),
            errorStyle: const TextStyle(color: Colors.red),
            //contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText =
                      !_obscureText; // Basculer la visibilité du texte
                });
              },
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.3),
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
              return AppLocalizations.of(context)?.needToBeCompleted ?? Constants.notAvailable;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class InputTextWithIcon extends StatefulWidget {
  final String description;
  final String? height;
  final TextEditingController? controller;
  final Icon iconique;

  const InputTextWithIcon({
    super.key,
    required this.description,
    this.height,
    this.controller,
    required this.iconique,
  });

  @override
  _InputTextWithIconState createState() => _InputTextWithIconState();
}

class _InputTextWithIconState extends State<InputTextWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        height: 80,
        width: 350,
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(
              fontSize: 13),
          decoration: InputDecoration(
            labelText: widget
                .description,
            labelStyle: const TextStyle(
                color: Constants.darkGrey), 
            suffixIcon:
                widget.iconique,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0.3),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0,
                  color: Constants
                      .darkBlue),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1.0,
                  color: Colors
                      .red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1.0,
                  color: Colors
                      .red),
            ),
          ),
        ),
      ),
    );
  }
}
