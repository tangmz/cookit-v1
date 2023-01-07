// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF67952);
const Color bgColor = Color(0xFFFBFBFD);

const double defaultPadding = 16.0;
const double defaultBorderRadius = 80;

class DropDownModel {
  String name;
  IconData icon;
  DropDownModel(this.name, this.icon);
}

List<DropDownModel> menuItems = [
  DropDownModel('Edit', Icons.edit_note),
  DropDownModel('Delete', Icons.delete_forever_outlined),
];
