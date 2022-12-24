import 'package:flutter/material.dart';

import '../models/posts_model.dart';

class RecipeTabIndg extends StatefulWidget {
  final Post selectedPost;
  const RecipeTabIndg({required this.selectedPost, super.key});

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
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("Test"));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0,
        );
      },
    );
  }
}
