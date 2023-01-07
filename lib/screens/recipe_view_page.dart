// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_mobile/models/reviews_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../models/posts_model.dart';
import '../models/user_model.dart';
import '../utils/config.dart';
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
  var floatingTitle = 'Cook Now';
  var postAuthor = 'unknown';
  late VoidCallback floatingOnPressed;

  void readAuthorName() async {
    await Config.dbInstance
        .collection('users')
        .withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (userItem, options) => userItem.toFirestore(),
        )
        .doc(widget.selectedPost.userID)
        .get()
        .then((result) {
      setState(() {
        postAuthor = result.data()!.userName;
      });
    });
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      starSize: 30,
      starColor: Theme.of(context).primaryColor,
      title: const Text('Rate the Recipe'),
      submitButtonText: 'Submit',
      onCancelled: () {},
      onSubmitted: (response) async {
        await Config.dbInstance
            .collection('recipePosts')
            .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (postItem, options) => postItem.toFirestore(),
            )
            .doc(widget.selectedPost.postID!)
            .update({
          'reviews': FieldValue.arrayUnion([
            {
              'userName': Config.authInstance.currentUser!.displayName,
              'userID': Config.authInstance.currentUser!.uid,
              'comments':
                  response.comment == '' ? 'No Comment' : response.comment,
              'ratings': response.rating,
            }
          ])
        }).then((value) {
          setState(() {
            widget.selectedPost.reviews!.add(Reviews(
                userID: Config.authInstance.currentUser!.uid,
                userName: Config.authInstance.currentUser!.displayName,
                comments:
                    response.comment == '' ? 'No Comment' : response.comment,
                ratings: response.rating));

            widget.selectedPost.postRatings = widget.selectedPost.reviews!
                    .map((ele) => ele.ratings)
                    .reduce((a, b) => a! + b!)! /
                widget.selectedPost.reviews!.length;
          });
        });

        widget.selectedPost.reviews!.isNotEmpty
            ? widget.selectedPost.reviews!
                    .map((ele) => ele.ratings)
                    .reduce((a, b) => a! + b!)! /
                widget.selectedPost.reviews!.length
            : response.rating;

        await Config.dbInstance
            .collection('recipePosts')
            .doc(widget.selectedPost.postID!)
            .update({
          'postRatings': widget.selectedPost.reviews!
                  .map((ele) => ele.ratings)
                  .reduce((a, b) => a! + b!)! /
              widget.selectedPost.reviews!.length
        });

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
                              'Successful!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Thanks for leaving a review!',
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
            floatingTitle = 'Cook Now';
            floatingOnPressed =
                () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => CookingPage(
                          selectedPost: widget.selectedPost,
                        )));
          }
          break;
        case 1:
          {
            floatingTitle = 'Cook Now';
            floatingOnPressed =
                () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => CookingPage(
                          selectedPost: widget.selectedPost,
                        )));
          }
          break;
        case 2:
          {
            floatingTitle = 'Write Review';
            floatingOnPressed = () => _showRatingAppDialog();
          }
          break;
      }
    });
  }

  @override
  void initState() {
    readAuthorName();
    super.initState();
    tabChange(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollGlowBehaviour(),
        child: CustomScrollView(
          slivers: <Widget>[
            RecipeAppBar(selectedPost: widget.selectedPost),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedPost.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   'Shared By: $postAuthor',
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 1,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: 'Shared By:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(text: ' $postAuthor')
                            ])),
                      ),
                      Flexible(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${widget.selectedPost.servSize} pax. '),
                          Icon(
                            Octicons.person_add,
                            size: 15,
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ))
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.25,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                ),
                                Text(
                                  ' ${widget.selectedPost.prepTime} mins',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.25,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.selectedPost.difficulty == 'Easy'
                                    ? MaterialCommunityIcons.signal_cellular_1
                                    : widget.selectedPost.difficulty == 'Medium'
                                        ? MaterialCommunityIcons
                                            .signal_cellular_2
                                        : MaterialCommunityIcons
                                            .signal_cellular_3),
                                Text(
                                  ' ${widget.selectedPost.difficulty}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.25,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                ),
                                Text(
                                  ' ${widget.selectedPost.postRatings!.toStringAsFixed(1)}   ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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
