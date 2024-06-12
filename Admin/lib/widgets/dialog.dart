import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/widgets/button.dart';

abstract class _BaseDialog extends StatelessWidget {
  final String message;
  final String descriptionButton;
  final String titreDialog;

  const _BaseDialog({
    required this.titreDialog,
    required this.message,
    required this.descriptionButton,
  });
}

class ErrorDialog extends _BaseDialog {
  const ErrorDialog({
    required super.titreDialog,
    required super.message,
    required super.descriptionButton,
  });

  void goBackForm(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Constants.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Center(child: Text(titreDialog)),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        BlueButton(
          description: descriptionButton,
          onPressed: () => goBackForm(context),
        ),
      ],
    );
  }
}
