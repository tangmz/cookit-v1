import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../models/posts_model.dart';
import '../screens/cooking_page.dart';
import '../widgets/recipe_app_bar.dart';
import '../widgets/recipe_body.dart';

class RecipeViewPage extends StatefulWidget {
  final Post selectedPost;

  RecipeViewPage({required this.selectedPost, super.key});

  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  var floatingTitle = "Cook Now";
  late VoidCallback floatingOnPressed;

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      starColor: Theme.of(context).primaryColor,
      title: const Text("Rate the Recipe"),
      submitButtonText: 'Submit',
      onCancelled: () {},
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Successful!",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Thanks for leaving a review!",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Positioned(
                  height: 80,
                  left: 15,
                  child: Icon(
                    Icons.check,
                    color: Colors.green[900],
                    size: 50,
                  ))
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  void tabChange(int tabNum) {
    setState(() {
      switch (tabNum) {
        case 0:
          {
            floatingTitle = "Cook Now";
            floatingOnPressed =
                () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CookingPage(
                          selectedPost: widget.selectedPost,
                        )));
          }
          break;
        case 1:
          {
            floatingTitle = "Cook Now";
            floatingOnPressed =
                () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CookingPage(
                          selectedPost: widget.selectedPost,
                        )));
          }
          break;
        case 2:
          {
            floatingTitle = "Write Review";
            floatingOnPressed = () => _showRatingAppDialog();
          }
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tabChange(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          RecipeAppBar(selectedPost: widget.selectedPost),
          SliverToBoxAdapter(
            child: Text(
              widget.selectedPost.title,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          SliverToBoxAdapter(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RecipeBody(
                  selectedPost: widget.selectedPost,
                  tabChange: tabChange,
                )),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          height: 50,
          width: 130,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: floatingOnPressed,
            child: Text(
              floatingTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )),
    );
  }
}
