// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

import '../models/posts_model.dart';

class RecipeTabInfo extends StatefulWidget {
  final Post selectedPost;
  const RecipeTabInfo({required this.selectedPost, super.key});

  @override
  State<RecipeTabInfo> createState() => _RecipeTabInfoState();
}

class _RecipeTabInfoState extends State<RecipeTabInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            widget.selectedPost.desc!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          )),
    );
  }
}
