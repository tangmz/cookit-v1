// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit_mobile/screens/bottom_navigation_tab.dart';
import 'package:cookit_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/double_layer_text.dart';

class ProfilePageHeader extends SliverPersistentHeaderDelegate {
  BuildContext ctx;
  late double minHeight;
  late double expandedHeight;

  ProfilePageHeader({required this.ctx}) {
    minHeight = MediaQuery.of(ctx).padding.top + kToolbarHeight;
    expandedHeight = MediaQuery.of(ctx).size.height * 0.28;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildAppBar(shrinkOffset),
        buildBackground(shrinkOffset, context),
        Positioned(
          top: MediaQuery.of(context).viewPadding.top + 3,
          right: 0,
          child: IconButton(
            tooltip: 'Logout',
            onPressed: () => Config.authInstance.signOut(),
            icon: Icon(Icons.logout_rounded),
            color: Theme.of(context).canvasColor,
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(double shrinkOffset) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
          title: CircleAvatar(
            child: ClipOval(
              child: Config.authInstance.currentUser?.photoURL == null
                  ? const Icon(Icons.people)
                  : CachedNetworkImage(
                      imageUrl: Config.authInstance.currentUser!.photoURL!,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
          ),
          backgroundColor: Theme.of(ctx).primaryColor,
          centerTitle: true,
        ),
      );

  Widget buildBackground(double shrinkOffset, BuildContext ctx) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Stack(fit: StackFit.expand, children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: 'https://source.unsplash.com/random?dark',
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints.tightFor(
                  height: max(minHeight, expandedHeight)),
              padding: EdgeInsets.only(top: minHeight - 20),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(ctx).primaryColor),
                      child: CircleAvatar(
                          radius: 40,
                          child: ClipOval(
                            child: Config.authInstance.currentUser?.photoURL ==
                                    null
                                ? Icon(Icons.people)
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: Config
                                        .authInstance.currentUser!.photoURL!,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                          )),
                    ),
                    DoubleText(
                      topText: Config.authInstance.currentUser!.displayName!,
                      bottomText: 'ID: ${Config.authInstance.currentUser!.uid}',
                      textColor: Colors.white,
                    ),
                    // Text(style: TextStyle(color: Colors.white), 'Username'),
                  ],
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DoubleText(
                        topText: BottomNavigationTab
                            .favIDListController.favIDList.length
                            .toString(),
                        bottomText: "Favourites",
                        bottomSize: 10,
                        textColor: Colors.white,
                        alignment: CrossAxisAlignment.center,
                      ),
                      SizedBox(width: 30),
                      DoubleText(
                        topText: BottomNavigationTab
                            .favIDListController.publishedNum.value
                            .toString(),
                        bottomText: "Post Counts",
                        bottomSize: 10,
                        textColor: Colors.white,
                        alignment: CrossAxisAlignment.center,
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ]),
      );
}
