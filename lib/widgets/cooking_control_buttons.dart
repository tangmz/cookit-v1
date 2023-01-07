// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'package:cookit_mobile/screens/cooking_page.dart';

class CookingStepControlButtons extends StatelessWidget {
  const CookingStepControlButtons({
    Key? key,
    required int pageIndex,
    required PageController pageController,
    required this.widget,
  })  : _pageIndex = pageIndex,
        _pageController = pageController,
        super(key: key);

  final int _pageIndex;
  final PageController _pageController;
  final CookingPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
            onPressed: _pageIndex == 0
                ? null
                : () => _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn),
            icon: Icon(Icons.arrow_back_ios_new),
            label: Text("Previous"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                fixedSize: Size(150, 40))),
        ElevatedButton.icon(
            onPressed: _pageIndex == widget.selectedPost.steps!.length - 1
                ? () => Navigator.pop(context)
                : () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn),
            icon: _pageIndex == widget.selectedPost.steps!.length - 1
                ? Icon(Icons.check)
                : Icon(Icons.arrow_forward_ios),
            label: _pageIndex == widget.selectedPost.steps!.length - 1
                ? Text("Done")
                : Text("Next"),
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    _pageIndex == widget.selectedPost.steps!.length - 1
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                fixedSize: Size(150, 40))),
      ],
    );
  }
}
