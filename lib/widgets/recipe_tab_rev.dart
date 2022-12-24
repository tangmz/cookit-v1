import 'package:flutter/material.dart';

import '../models/posts_model.dart';

class RecipeTabRev extends StatefulWidget {
  final Post selectedPost;
  const RecipeTabRev({required this.selectedPost, super.key});

  @override
  State<RecipeTabRev> createState() => _RecipeTabRevState();
}

class _RecipeTabRevState extends State<RecipeTabRev> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Text("User"),
          title: Text("Comments"),
          trailing: SizedBox(
            width: 50,
            child: Row(
              children: [Text("5.0"), Icon(Icons.star_rate)],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0,
        );
      },
    );
  }
}
