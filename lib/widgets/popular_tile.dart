import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/posts_model.dart';

class PopularTile extends StatefulWidget {
  final Post currentPost;
  final VoidCallback onClicked;

  const PopularTile(
      {required this.currentPost, required this.onClicked, super.key});

  @override
  State<PopularTile> createState() => _PopularTileState();
}

class _PopularTileState extends State<PopularTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.currentPost.posterSrc,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  widget.currentPost.title)),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  widget.currentPost.desc)),
        ]),
        Positioned(
          top: 10,
          right: 12,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.currentPost.isFavourite =
                    !widget.currentPost.isFavourite;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text(
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      '10'),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
