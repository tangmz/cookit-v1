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
    if (widget.selectedPost.reviews == null ||
        widget.selectedPost.reviews!.isNotEmpty) {
      return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: widget.selectedPost.reviews!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: SizedBox(
              width: MediaQuery.of(context).size.shortestSide * 0.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline),
                  Flexible(
                    child: Text(
                      widget.selectedPost.reviews![index].userName!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            title: Text(widget.selectedPost.reviews![index].comments!),
            trailing: SizedBox(
              width: 50,
              child: Row(
                children: [
                  Text(widget.selectedPost.reviews![index].ratings!
                      .toStringAsFixed(1)),
                  Icon(Icons.star_rate)
                ],
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
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.38,
        alignment: Alignment.center,
        child: Text('No Reviews Yet'),
      );
    }
  }
}
