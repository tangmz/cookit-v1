// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/posts_model.dart';
import '../screens/bottom_navigation_tab.dart';
import '../utils/config.dart';

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
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.currentPost.posterSrc!,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Positioned(
                  top: 5,
                  right: 5,
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          (widget.currentPost.postRatings == null ||
                                  widget.currentPost.postRatings! == 0.0)
                              ? Icons.star_outline
                              : Icons.star,
                          color: Colors.yellow[600],
                          size: 16,
                        ),
                        Text(
                          (widget.currentPost.postRatings == null ||
                                  widget.currentPost.postRatings! == 0.0)
                              ? 0.toString()
                              : widget.currentPost.postRatings!
                                  .toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            widget.currentPost.title!),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          '${widget.currentPost.prepTime!}mins',
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                widget.currentPost.desc!)),
                        Row(
                          children: [
                            Obx(
                              () => IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                color: Colors.black,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (BottomNavigationTab
                                      .favIDListController.favIDList.value
                                      .contains(widget.currentPost.postID)) {
                                    Config.removeFromFav(
                                        widget.currentPost.postID!);
                                  } else {
                                    Config.addToFav(widget.currentPost.postID!);
                                  }
                                },
                                icon: Icon(
                                  BottomNavigationTab
                                          .favIDListController.favIDList.value
                                          .contains(widget.currentPost.postID)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  size: 16,
                                  color: BottomNavigationTab
                                          .favIDListController.favIDList.value
                                          .contains(widget.currentPost.postID)
                                      ? Colors.red
                                      : Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            Text(
                                style: TextStyle(fontSize: 14),
                                widget.currentPost.favCount.toString()),
                          ],
                        ),
                      ]),
                ]),
          )
        ],
      ),
    );
  }
}
