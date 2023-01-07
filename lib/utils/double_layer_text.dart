// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

class DoubleText extends StatelessWidget {
  DoubleText(
      {super.key,
      required this.topText,
      required this.bottomText,
      this.textColor = Colors.black,
      this.alignment = CrossAxisAlignment.start,
      this.topSize = 18,
      this.bottomSize = 12,
      this.spacing = 5});

  String topText;
  String bottomText;
  Color textColor;
  double topSize;
  double bottomSize;
  double spacing;
  CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
              style: TextStyle(
                  fontSize: topSize,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
              maxLines: 1,
              topText),
          SizedBox(
            height: spacing,
          ),
          Text(
              style: TextStyle(
                  fontSize: bottomSize,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
              maxLines: 1,
              bottomText),
        ],
      ),
    );
  }
}
