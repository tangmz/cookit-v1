import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../models/posts_model.dart';
import '../screens/recipe_view_page.dart';
import './popular_tile.dart';
import './post_tile.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});
  List<Post> get allPost => recipePosts;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            "Popular",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: widget.allPost.length,
          itemBuilder: (context, index) {
            return OpenContainer(
              closedElevation: 0,
              closedColor: Colors.grey.shade50,
              closedBuilder: (context, VoidCallback openContainer) =>
                  (PopularTile(
                currentPost: widget.allPost[index],
                onClicked: openContainer,
              )),
              openBuilder: (context, VoidCallback _) =>
                  RecipeViewPage(selectedPost: widget.allPost[index]),
            );
            // return PopularTile(
            //   currentPost: widget.allPost[index],
            // );
          },
          // separatorBuilder: (BuildContext context, int index) {
          //   return Divider();
          // },
        )
      ],
    );
  }
}
