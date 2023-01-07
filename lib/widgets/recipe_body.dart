// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

import '../widgets/recipe_tab_indg.dart';
import '../widgets/recipe_tab_info.dart';
import '../widgets/recipe_tab_rev.dart';

import '../models/posts_model.dart';

class RecipeBody extends StatefulWidget {
  final Post selectedPost;
  Function tabChange;

  RecipeBody({required this.selectedPost, required this.tabChange, super.key});

  @override
  State<RecipeBody> createState() => _RecipeBodyState();
}

class _RecipeBodyState extends State<RecipeBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      widget.tabChange(_tabController.index);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: kToolbarHeight - 8.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 173, 173, 173)),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Ingredients",
                ),
                Tab(
                  text: "Info",
                ),
                Tab(
                  text: "Reviews",
                ),
              ]),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 55),
          child: [
            RecipeTabIndg(selectedPost: widget.selectedPost),
            RecipeTabInfo(selectedPost: widget.selectedPost),
            RecipeTabRev(selectedPost: widget.selectedPost),
          ][_tabController.index],
        )
      ],
    );
  }
}
