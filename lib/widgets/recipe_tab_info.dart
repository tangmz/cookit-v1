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
      child: Text(widget.selectedPost.desc),
    );
  }
}
