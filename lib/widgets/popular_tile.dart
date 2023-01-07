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
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.currentPost.posterSrc!,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      widget.currentPost.title!)),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        Text(
                          ' ${widget.currentPost.prepTime!}mins',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 5,
                        ),
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
                      ]),
                ),
              )
            ],
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.currentPost.desc!)),
        ]),
        Positioned(
          top: 10,
          right: 12,
          child: InkWell(
            onTap: () {
              if (BottomNavigationTab.favIDListController.favIDList.value
                  .contains(widget.currentPost.postID)) {
                Config.removeFromFav(widget.currentPost.postID!);
              } else {
                Config.addToFav(widget.currentPost.postID!);
              }
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
                          Config.removeFromFav(widget.currentPost.postID!);
                        } else {
                          Config.addToFav(widget.currentPost.postID!);
                        }
                      },
                      icon: Icon(
                        BottomNavigationTab.favIDListController.favIDList.value
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      widget.currentPost.favCount.toString()),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
