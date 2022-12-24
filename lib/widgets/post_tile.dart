import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/posts_model.dart';

class PostTile extends StatefulWidget {
  final Post currentPost;

  PostTile({required this.currentPost, super.key});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.currentPost.posterSrc,
              fit: BoxFit.cover,
            ),
          ),
          Text(
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              widget.currentPost.title),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    widget.currentPost.desc)),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashColor: Colors.transparent,
                  icon: Icon(
                    widget.currentPost.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.currentPost.isFavourite =
                          !widget.currentPost.isFavourite;
                    });
                  },
                ),
                Text(style: TextStyle(fontSize: 14), '10'),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
