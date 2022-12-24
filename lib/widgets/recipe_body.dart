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

  int _selectedTab = 0;

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
        TabBar(controller: _tabController, labelColor: Colors.black,
            // onTap: (index) {
            //   setState(() {
            //     _selectedTab = index;
            //   });
            // },
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
        Container(
          child: [
            RecipeTabIndg(selectedPost: widget.selectedPost),
            RecipeTabInfo(selectedPost: widget.selectedPost),
            RecipeTabRev(selectedPost: widget.selectedPost),
          ][_tabController.index],
        )
        // Builder(builder: (_) {
        //   if (_selectedTab == 0) {
        //     return Container(
        //       child: RecipeTabIndg(selectedPost: widget.selectedPost),
        //     );
        //   } else if (_selectedTab == 1) {
        //     return Container(
        //       child: RecipeTabInfo(selectedPost: widget.selectedPost),
        //     );
        //   } else {
        //     return Container(
        //       child: RecipeTabRev(selectedPost: widget.selectedPost),
        //     );
        //   }
        // }),
        // RecipeTabIndg(selectedPost: widget.selectedPost),
        // Container(
        //   height: 800,
        //   child: TabBarView(controller: _tabController, children: [
        //     Container(
        //       child: RecipeTabIndg(selectedPost: widget.selectedPost),
        //     ),
        //     Container(
        //       child: RecipeTabInfo(selectedPost: widget.selectedPost),
        //     ),
        //     Container(
        //       child: RecipeTabRev(selectedPost: widget.selectedPost),
        //     )
        //   ]),
        // )
      ],
    );
  }
}
