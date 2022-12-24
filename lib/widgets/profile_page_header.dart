import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/double_layer_text.dart';

class ProfilePageHeader extends SliverPersistentHeaderDelegate {
  BuildContext ctx;
  late double minHeight;
  late double expandedHeight;

  ProfilePageHeader({required this.ctx}) {
    minHeight = MediaQuery.of(ctx).padding.top + kToolbarHeight;
    expandedHeight = MediaQuery.of(ctx).size.height * 0.23;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildAppBar(shrinkOffset),
        buildBackground(shrinkOffset),
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
          title: CircleAvatar(child: Icon(Icons.people)),
          backgroundColor: Theme.of(ctx).primaryColor,
          centerTitle: true,
        ),
      );

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Stack(fit: StackFit.expand, children: [
          Image.network(
            'https://source.unsplash.com/random?monochromatic+dark',
            fit: BoxFit.cover,
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
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple),
                          borderRadius: BorderRadius.circular(40)),
                      child: CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.people),
                      ),
                    ),
                    DoubleText(
                      topText: "Username",
                      bottomText: "ID",
                      textColor: Colors.white,
                    ),
                    // Text(style: TextStyle(color: Colors.white), 'Username'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DoubleText(
                      topText: 123.toString(),
                      bottomText: "Favourites",
                      bottomSize: 10,
                      textColor: Colors.white,
                      alignment: CrossAxisAlignment.center,
                    ),
                    SizedBox(width: 30),
                    DoubleText(
                      topText: 234.toString(),
                      bottomText: "Post Counts",
                      bottomSize: 10,
                      textColor: Colors.white,
                      alignment: CrossAxisAlignment.center,
                    )
                  ],
                )
              ]),
            ),
          ),
        ]),
      );
}
