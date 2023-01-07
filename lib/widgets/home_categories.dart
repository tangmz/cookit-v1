// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit_mobile/screens/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../models/category_model.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        itemBuilder: (context, index) => Categories(
          icon: categoriesList[index].icon,
          title: categoriesList[index].title,
          press: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      SearchPage(pageTitle: categoriesList[index].title),
                ));
          },
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(width: defaultPadding),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(defaultBorderRadius)),
            ),
            backgroundColor: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding / 2, horizontal: defaultPadding / 8),
          child: Column(
            children: [
              CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: icon,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
