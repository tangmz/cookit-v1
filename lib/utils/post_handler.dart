// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_mobile/screens/add_recipe_summ.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../models/posts_model.dart';
import '../models/steps_model.dart';
import '../models/user_model.dart';
import '../screens/add_recipe_step.dart';
import 'config.dart';

class PostHandler {
  static Future<bool> addRecipeUpload(MyCardList cards, RecipeSummary summary,
      BuildContext context, BuildContext ctx) async {
    if (int.tryParse(summary.servController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Numbers Only In Serving Size!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return false;
    }
    if (cards.cards.isNotEmpty &&
        summary.titleController.text.trim() != '' &&
        (summary.selectedImage != null || summary.autoImageURL != '')) {
      //Triggers a Loader to Load in Screen

      try {
        //Creates an Empty Document Reference
        DocumentReference docRef = Config.dbInstance
            .collection('recipePosts')
            .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (Post postItem, options) => postItem.toFirestore(),
            )
            .doc();

        //Upload Poster Image to Cloud Drives (if available)
        var posterURL = summary.autoImageURL;

        if (summary.selectedImage != null && summary.autoImageURL == '') {
          try {
            var ref = await Config.cloudInstance
                .ref()
                .child('recipePhoto')
                .child(docRef.id)
                .child('${docRef.id}_poster.jpg');

            await ref.putFile(summary.selectedImage!);

            posterURL = await ref.getDownloadURL();
          } on FirebaseException catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error Uploading Image'),
              backgroundColor: Theme.of(context).errorColor,
            ));
            return false;
          }
        }

        //Upload Steps Images to Cloud Drives
        var stepsImgURL = <String>[];

        for (var element in cards.imageFiles) {
          print(element != null);
          if (element != null) {
            try {
              await Config.cloudInstance
                  .ref()
                  .child('recipePhoto')
                  .child(docRef.id)
                  .child('${docRef.id}_${element.hashCode}.jpg')
                  .putFile(element)
                  .then(
                    (p0) async =>
                        stepsImgURL.add(await p0.ref.getDownloadURL()),
                  );
            } on FirebaseException catch (_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error Uploading Image(s)'),
                backgroundColor: Theme.of(context).errorColor,
              ));
              return false;
            }
          } else {
            stepsImgURL.add('');
          }
        }

        //Upload the Entire Recipe Post Data to Firestore
        docRef.set(Post(
          postID: docRef.id,
          userID: Config.authInstance.currentUser!.uid,
          posterSrc: posterURL,
          title: summary.titleController.text.titleCase,
          desc: summary.descController.text,
          category: summary.catController.text == ''
              ? 'Others'
              : summary.catController.text,
          difficulty: summary.recipeDifficulty,
          servSize: int.tryParse(summary.servController.text),
          prepTime: summary.prepMinute,
          postRatings: 0.0,
          steps: List<Steps>.generate(cards.cards.length, (index) {
            return Steps(
                stepDesc: cards.steps[index].text,
                indg: cards.indg[index].text
                    .split(',')
                    .map((e) => e.titleCase)
                    .toList(),
                stepImgSrc: stepsImgURL[index]);
          }),
        ));

        await Config.dbInstance
            .collection('users')
            .doc(Config.authInstance.currentUser!.uid)
            .update({
          'ownPostsID': FieldValue.arrayUnion([docRef.id])
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('Post Upload Successful!'),
          backgroundColor: Colors.green[600],
        ));
      } on FirebaseException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Contacting To Server'),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please Check If All Fields Are Filled Completely'),
      backgroundColor: Theme.of(context).errorColor,
    ));
    return false;
  }

  static Future<bool> editRecipeUpload(
      MyCardList cards,
      RecipeSummary summary,
      BuildContext context,
      BuildContext ctx,
      String? id,
      Map<String, dynamic> postMetadata) async {
    if (cards.cards.isNotEmpty &&
        summary.titleController.text.trim() != '' &&
        id != null &&
        (summary.selectedImage != null || summary.autoImageURL != '')) {
      //Triggers a Loader to Load in Screen

      try {
        //Find the Document Reference
        DocumentReference docRef = Config.dbInstance
            .collection('recipePosts')
            .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (Post postItem, options) => postItem.toFirestore(),
            )
            .doc(id);

        //Upload Poster Image to Cloud Drives (if available)
        var posterURL = summary.autoImageURL;

        if (summary.selectedImage != null && summary.autoImageURL == '') {
          try {
            var ref = Config.cloudInstance
                .ref()
                .child('recipePhoto')
                .child(docRef.id)
                .child('${docRef.id}_poster.jpg');

            await ref.putFile(summary.selectedImage!);

            posterURL = await ref.getDownloadURL();
          } on FirebaseException catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error Uploading Image'),
              backgroundColor: Theme.of(context).errorColor,
            ));
            return false;
          }
        }

        //Upload Steps Images to Cloud Drives, remain URL if no changes
        var stepsImgURL = <String>[];

        for (var i = 0; i < cards.steps.length; i++) {
          if (cards.imageURL[i] != '') {
            stepsImgURL.add(cards.imageURL[i]!);
          } else if (cards.imageFiles[i] != null) {
            try {
              await Config.cloudInstance
                  .ref()
                  .child('recipePhoto')
                  .child(docRef.id)
                  .child('${docRef.id}_${cards.imageFiles[i].hashCode}.jpg')
                  .putFile(cards.imageFiles[i]!)
                  .then(
                    (p0) async =>
                        stepsImgURL.add(await p0.ref.getDownloadURL()),
                  );
            } on FirebaseException catch (_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error Uploading Image(s)'),
                backgroundColor: Theme.of(context).errorColor,
              ));
              return false;
            }
          } else {
            stepsImgURL.add('');
          }
        }

        //Upload the Entire Recipe Post Data to Firestore
        docRef.set(Post(
          postID: id,
          userID: Config.authInstance.currentUser!.uid,
          posterSrc: posterURL,
          title: summary.titleController.text.titleCase,
          desc: summary.descController.text,
          category: summary.catController.text == ''
              ? 'Others'
              : summary.catController.text,
          difficulty: summary.recipeDifficulty,
          servSize: int.tryParse(summary.servController.text),
          prepTime: summary.prepMinute,
          favCount: postMetadata['favCount'],
          postRatings: postMetadata['postRatings'],
          reviews: postMetadata['reviews'],
          steps: List<Steps>.generate(cards.cards.length, (index) {
            return Steps(
                stepDesc: cards.steps[index].text,
                indg: cards.indg[index].text
                    .split(',')
                    .map((e) => e.titleCase)
                    .toList(),
                stepImgSrc: stepsImgURL[index]);
          }),
        ));

        Navigator.pop(context);
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('Post Edit Successful!'),
          backgroundColor: Colors.green[600],
        ));
      } on FirebaseException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Contacting To Server'),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }

      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please Check If All Fields Are Filled Completely'),
      backgroundColor: Theme.of(context).errorColor,
    ));
    return false;
  }

  static Future<void> deletePost(String postID, BuildContext ctx) async {
    try {
      //delete images from Firebase Storage
      var postImages = await Config.cloudInstance
          .ref()
          .child('recipePhoto')
          .child(postID)
          .listAll();
      for (var element in postImages.items) {
        await element.delete();
      }

      //delete data from Firestore
      await Config.dbInstance
          .collection('recipePosts')
          .doc(postID)
          .delete()
          .onError(
            (error, stackTrace) =>
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text('Error Deleting Document'),
              backgroundColor: Theme.of(ctx).errorColor,
            )),
          );

      //remove the postID from User Profile
      await Config.dbInstance
          .collection('users')
          .doc(Config.authInstance.currentUser!.uid)
          .update({
        'ownPostsID': FieldValue.arrayRemove([postID])
      });

      //remove the postID from users who favourites it
      await Config.dbInstance
          .collection('users')
          .withConverter(
            fromFirestore: Users.fromFirestore,
            toFirestore: (userItem, options) => userItem.toFirestore(),
          )
          .where('ownPostsID', arrayContains: postID)
          .get()
          .then((response) async {
        var batch = Config.dbInstance.batch();
        response.docs.forEach((doc) {
          batch.update(doc.reference, {
            'ownPostsID': FieldValue.arrayRemove([postID])
          });
        });
        await batch.commit();
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.message!),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }
}
