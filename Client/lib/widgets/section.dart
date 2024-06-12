import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';

abstract class BaseSectionLinks extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback onTapFunction;
  final String descriptionSection;

  const BaseSectionLinks({
    super.key,
    required this.icon,
    required this.title,
    required this.onTapFunction,
    this.descriptionSection = "",
  });
}

class SectionLinksDescription extends BaseSectionLinks {
  const SectionLinksDescription({
    super.key,
    required super.icon,
    required super.title,
    required super.onTapFunction,
    required super.descriptionSection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapFunction,
        child: SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 16)),
                ],
              ),
              Expanded(child: ArrowLink(onTap: onTapFunction)),
              Container(
                margin: const EdgeInsets.only(left: 5,right: 50),
                child: Text(descriptionSection, style: const TextStyle(color: Constants.darkGrey)),
              )
            ],
          ),
        ));
  }
}

class SectionLinksNoDescription extends BaseSectionLinks {
  const SectionLinksNoDescription({
    super.key,
    required super.icon,
    required super.title,
    required super.onTapFunction,
  });

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: SizedBox(
      height: 60,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16)),
          Expanded(child: ArrowLink(onTap: onTapFunction)),
        ],
      ),
    ));
  }
}

class ArrowLink extends StatelessWidget {
  final VoidCallback onTap;

  const ArrowLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.chevron_right_sharp,
            size: 30, color: Constants.darkBlue),
      ),
    );
  }
}
