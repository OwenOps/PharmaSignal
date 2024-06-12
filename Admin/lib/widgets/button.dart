import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';

abstract class _BaseButtonn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String description;

  const _BaseButtonn({
    super.key,
    required this.onPressed,
    required this.description,
  });
}

class BlueButton extends _BaseButtonn {
  const BlueButton({
    super.key,
    required super.onPressed,
    required super.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              const MaterialStatePropertyAll<Color>(Constants.darkBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide.none,
          ),
        ),
        child:
            Text(description, style: const TextStyle(color: Constants.white)),
      ),
    );
  }
}

class RedButtonWarning extends _BaseButtonn {
  const RedButtonWarning({
    super.key,
    required super.onPressed,
    required super.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
          side: MaterialStateProperty.all(
              const BorderSide(color: Colors.red, width: 1)),
        ),
        child: Text(description,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BlueButtonPop extends _BaseButtonn {
  const BlueButtonPop({
    super.key,
    required super.onPressed,
    required super.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 280,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll<Color>(Constants.darkBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))),
        child: Text(description,
            style: const TextStyle(
                color: Constants.white,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

abstract class _BaseBigButton extends _BaseButtonn {
  final Color colorButton;
  final Color colorText;

  const _BaseBigButton({
    super.key,
    required super.onPressed,
    required super.description,
    required this.colorText,
    required this.colorButton,
  });

   @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: 325,
      child: OutlinedButton(
        onPressed: onPressed, 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorButton),
          minimumSize: MaterialStateProperty.all<Size>(const Size(325, 58)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        child: Text(
          description,
          style:  TextStyle(color: colorText, fontSize: 18),
        ),
      ),
    );
  }
}

class BigBlueButton extends _BaseBigButton {
  const BigBlueButton({
    super.key, 
    required super.onPressed,
    required super.description, 
    super.colorButton = Constants.darkBlue,
    super.colorText = Constants.white,
  });
}

class BigWhiteButton extends _BaseBigButton {
  const BigWhiteButton({
    super.key,
    required super.onPressed,
    required super.description,
    super.colorButton = Constants.white,
    super.colorText = Colors.black,
  });
}
