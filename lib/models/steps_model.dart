// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

class Steps {
  String? stepImgSrc, stepDesc;
  List<String>? indg;
  Steps({stepDesc, stepImgSrc, indg})
      : stepDesc = stepDesc ?? '',
        stepImgSrc = stepImgSrc ?? '',
        indg = indg ?? [];
}
