// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

import '../models/posts_model.dart';

class RecipeTabIndg extends StatefulWidget {
  final Post selectedPost;
  late List<String?> ingredientsLst = selectedPost.steps!
      .map((e) => e.indg!)
      .expand((element) => element)
      .where((element) => element.isNotEmpty)
      .toSet()
      .toList();
  RecipeTabIndg({required this.selectedPost, super.key});

  @override
  State<RecipeTabIndg> createState() => _RecipeTabIndgState();
}

class _RecipeTabIndgState extends State<RecipeTabIndg> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: widget.ingredientsLst.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text(widget.ingredientsLst[index]!));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0,
        );
      },
    );
  }
}
