// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:recase/recase.dart';

import '../models/posts_model.dart';
import '../utils/config.dart';
import '../widgets/post_grid.dart';

class SearchPage extends StatefulWidget {
  String? pageTitle;
  SearchPage({required pageTitle, super.key})
      : pageTitle = pageTitle ?? 'Search Recipes';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textController = TextEditingController();
  // List<String> filterHighlight = ["Pork-Free", "Gluten-Free", "Vegeterian"];
  // List<bool> isChecked = List<bool>.generate(3, (index) => false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.longestSide * 0.08,
            backgroundColor: Theme.of(context).canvasColor,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text((widget.pageTitle! == 'Search Recipes' ||
                    widget.pageTitle! == 'Fast Food' ||
                    widget.pageTitle! == 'Pastries' ||
                    widget.pageTitle! == 'Others')
                ? widget.pageTitle!
                : '${widget.pageTitle!} Cuisines'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                  MediaQuery.of(context).size.longestSide * 0.06),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      spreadRadius: -15,
                      blurRadius: 20,
                      color: Theme.of(context).shadowColor,
                      offset: Offset(10, 5))
                ]),
                child: CupertinoSearchTextField(
                    controller: textController,
                    onSuffixTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        textController.text = '';
                      });
                    },
                    backgroundColor: Theme.of(context).bottomAppBarColor),
              ),
            ),
          ),
          body: StreamBuilder(
            stream: textController.text.trim().isEmpty
                ? Config.dbInstance
                    .collection('recipePosts')
                    .withConverter(
                      fromFirestore: Post.fromFirestore,
                      toFirestore: (postItem, options) =>
                          postItem.toFirestore(),
                    )
                    .where('category',
                        isEqualTo: widget.pageTitle! == 'Search Recipes'
                            ? null
                            : widget.pageTitle!)
                    .snapshots()
                : Config.dbInstance
                    .collection('recipePosts')
                    .withConverter(
                      fromFirestore: Post.fromFirestore,
                      toFirestore: (postItem, options) =>
                          postItem.toFirestore(),
                    )
                    .where('category',
                        isEqualTo: widget.pageTitle! == 'Search Recipes'
                            ? null
                            : widget.pageTitle!)
                    .orderBy('title')
                    .startAt([
                    textController.text.titleCase,
                  ]).endAt([
                    '${textController.text.titleCase}\uf8ff',
                  ]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return (snapshot.data == null ||
                      snapshot.data!.docs.map((e) => e.data()).toList().isEmpty)
                  ? ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [Image.asset('assets/images/No_Result.png')],
                    )
                  : PostGrid(
                      allPost:
                          snapshot.data!.docs.map((e) => e.data()).toList());
            },
          ),
        ));
  }
}
