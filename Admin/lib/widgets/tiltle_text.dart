import 'package:flutter/material.dart';
import 'package:mobile_application/utils/constants.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double? fontSize;

  const TitleText({
    super.key,
    required this.title,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Constants.white),
      ),
    );
  }
}

class SubTitleText extends TitleText {
  const SubTitleText(String title, {super.key, super.fontSize = 15})
      : super(
          title: title,
        );
}
