// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit_mobile/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../models/posts_model.dart';
import '../screens/add_edit_recipe_page.dart';
import '../screens/bottom_navigation_tab.dart';
import '../utils/constants.dart';
import '../utils/post_handler.dart';

class RecipeAppBar extends StatefulWidget {
  final Post selectedPost;

  RecipeAppBar({required this.selectedPost, super.key});

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
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          width: 30,
          child: Obx(
            () => IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
              color: Colors.black,
              splashColor: Colors.transparent,
              onPressed: () {
                if (BottomNavigationTab.favIDListController.favIDList.value
                    .contains(widget.selectedPost.postID)) {
                  Config.removeFromFav(widget.selectedPost.postID!);
                } else {
                  Config.addToFav(widget.selectedPost.postID!);
                }
              },
              icon: Icon(
                BottomNavigationTab.favIDListController.favIDList.value
                        .contains(widget.selectedPost.postID)
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: BottomNavigationTab.favIDListController.favIDList.value
                        .contains(widget.selectedPost.postID)
                    ? Colors.red
                    : Theme.of(context).hintColor,
                size: 20,
              ),
            ),
          ),
        ),
        widget.selectedPost.userID == Config.authInstance.currentUser!.uid
            ? Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                width: 30,
                child: PopupMenuButton(
                  constraints: BoxConstraints(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onSelected: (item) async {
                    if (item == 'Edit') {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: AddEditRecipePage(
                                ctx: context,
                                selectedPost: widget.selectedPost,
                              )));
                    } else if (item == 'Delete') {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('Delete'),
                          content: Text(
                              'Are you sure you want to delete this item?'),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                isDefaultAction: true,
                                isDestructiveAction: true,
                                child: Text('Yes')),
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                isDefaultAction: false,
                                isDestructiveAction: false,
                                child: Text('No')),
                          ],
                        ),
                      ).then((value) async {
                        if (value == true) {
                          await PostHandler.deletePost(
                              widget.selectedPost.postID!, context);
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Icon(Icons.more_horiz, color: Colors.black),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: menuItems[0].name,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          menuItems[0].icon,
                          color: Colors.black,
                        ),
                        SizedBox(width: 40, child: Text(menuItems[0].name)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: menuItems[1].name,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          menuItems[1].icon,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(width: 50, child: Text(menuItems[1].name))
                      ]),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()
      ],
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.selectedPost.posterSrc!,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
