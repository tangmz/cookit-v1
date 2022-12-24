import 'package:flutter/material.dart';

import '../models/posts_model.dart';

class RecipeAppBar extends StatefulWidget {
  final Post selectedPost;

  const RecipeAppBar({required this.selectedPost, super.key});

  @override
  State<RecipeAppBar> createState() => _RecipeAppBarState();
}

class _RecipeAppBarState extends State<RecipeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: Container(
        margin: EdgeInsets.all(13),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              // offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: IconButton(
          padding: EdgeInsets.only(left: 8),
          constraints: BoxConstraints(),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                // offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            padding: EdgeInsets.all(6),
            constraints: BoxConstraints(),
            color: Colors.black,
            onPressed: () {
              setState(() {
                widget.selectedPost.isFavourite =
                    !widget.selectedPost.isFavourite;
              });
            },
            icon: Icon(widget.selectedPost.isFavourite
                ? Icons.favorite
                : Icons.favorite_border),
            //replace with our own icon data.
          ),
        ),
      ],
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.selectedPost.posterSrc,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
