// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cookit_mobile/screens/bottom_navigation_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/posts_model.dart';
import '../screens/search_page.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_body.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home-page';
  const HomePage({super.key});
  final String title = 'Cookit';

  @override
  Widget build(BuildContext context) {
    return Obx(() => (BottomNavigationTab.hasConnection.value)
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 5),
                      child: InkWell(
                        //==============INSERT SOMETHING HERE==============
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SearchPage(
                                      pageTitle: 'Search Recipes',
                                    ))),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 20, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black12),
                              color: Theme.of(context).canvasColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: -15,
                                  blurRadius: 20,
                                  offset: Offset(10, 10),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Search Cookit | ",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold)),
                                  AnimatedTextKit(
                                    onTap: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => SearchPage(
                                                  pageTitle: 'Search Recipes',
                                                ))),
                                    animatedTexts: titleIterator
                                        .map((title) => TyperAnimatedText(
                                              title,
                                              textStyle: TextStyle(
                                                  color: Colors.black38),
                                            ))
                                        .toList(),
                                    stopPauseOnTap: false,
                                    repeatForever: true,
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    HomeCategories(),
                    HomeBody(),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Image.asset('assets/images/Connection_Lost.png'),
          ));
  }
}
