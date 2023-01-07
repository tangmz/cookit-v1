// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cookit_mobile/models/posts_model.dart';
import 'package:cookit_mobile/screens/add_recipe_step.dart';
import 'package:cookit_mobile/screens/add_recipe_summ.dart';
import 'package:cookit_mobile/utils/post_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddEditRecipePage extends StatefulWidget {
  BuildContext ctx;
  Post? selectedPost;
  static const routeName = '/add-recipe-page';
  AddEditRecipePage({required this.ctx, this.selectedPost, super.key});

  @override
  State<AddEditRecipePage> createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  PageController _pageController = PageController(initialPage: 0);
  final _cards = Get.put(MyCardList());
  final _summary = Get.put(RecipeSummary());
  var _saveLoader = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedPost != null) buildPage();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<MyCardList>();
    Get.delete<RecipeSummary>();
  }

  void buildPage() {
    _summary.autoImageURL = widget.selectedPost!.posterSrc!;
    _summary.titleController.text = widget.selectedPost!.title!;
    _summary.descController.text = widget.selectedPost!.desc!;
    _summary.catController.text = widget.selectedPost!.category!;
    _summary.recipeDifficulty = widget.selectedPost!.difficulty!;
    _summary.servController.text = widget.selectedPost!.servSize!.toString();
    _summary.prepMinute = widget.selectedPost!.prepTime!;
    widget.selectedPost!.steps!.map((e) {
      // const has to be ignored because multiple instances have to be built for MyCard class
      // ignore: prefer_const_constructors
      _cards.cards.add(MyCard());
      _cards.steps.add(TextEditingController()..text = e.stepDesc!);
      _cards.indg.add(TextEditingController()..text = e.indg!.join(','));
      _cards.imageFiles.add(null);
      _cards.imageURL.add(e.stepImgSrc!);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    _saveLoader = true;
                  });
                  widget.selectedPost == null
                      ? PostHandler.addRecipeUpload(
                              _cards, _summary, context, widget.ctx)
                          .then((value) {
                          setState(() {
                            _saveLoader = value;
                          });
                        })
                      : PostHandler.editRecipeUpload(_cards, _summary, context,
                          widget.ctx, widget.selectedPost!.postID, {
                          'favCount': widget.selectedPost!.favCount,
                          'postRatings':
                              (widget.selectedPost!.postRatings == null ||
                                      widget.selectedPost!.postRatings! == 0.0)
                                  ? 0.toString()
                                  : widget.selectedPost!.postRatings!
                                      .toStringAsFixed(1),
                          'reviews': widget.selectedPost!.reviews
                        }).then((value) {
                          setState(() {
                            _saveLoader = value;
                          });
                        });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    foregroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    overlayColor: MaterialStateProperty.all(Colors.white30),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                child: _saveLoader
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text("Save"),
              ),
            )
          ],
          title: widget.selectedPost == null
              ? Text("Post a New Recipe")
              : Text('Edit Recipe')),
      body: Column(
        children: [
          Expanded(
            child: PageView(controller: _pageController, children: [
              AddRecipeSumm(),
              AddRecipeStep(
                cardList: _cards,
              )
            ]),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SmoothPageIndicator(
              controller: _pageController,
              effect: ScaleEffect(
                  dotColor: (Colors.grey[500])!,
                  activeDotColor: Theme.of(context).primaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 10),
              count: 2,
            ),
          )
        ],
      ),
    );
  }
}
