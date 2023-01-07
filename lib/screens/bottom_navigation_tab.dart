// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:async';

import 'package:cookit_mobile/screens/add_edit_recipe_page.dart';
import 'package:cookit_mobile/screens/home_page.dart';
import 'package:cookit_mobile/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../models/user_model.dart';
import '../utils/config.dart';

class BottomNavigationTab extends StatefulWidget {
  static final favIDListController = Get.put(favController());
  final FlutterNetworkConnectivity _flutterNetworkConnectivity =
      FlutterNetworkConnectivity(
    isContinousLookUp:
        true, // optional, false if you cont want continous lookup
    lookUpDuration: const Duration(
        seconds: 5), // optional, to override default lookup duration
    lookUpUrl: 'google.com', // optional, to override default lookup url
  );
  static final hasConnection = true.obs;
  BottomNavigationTab({super.key});

  @override
  State<BottomNavigationTab> createState() => _BottomNavigationTabState();
}

class _BottomNavigationTabState extends State<BottomNavigationTab> {
  late List _pages;
  int _selectedPageIndex = 0;
  late StreamSubscription<dynamic> _streamFavSubscription;
  late StreamSubscription<dynamic> _streamPublishedSubscription;
  late StreamSubscription _streamConnectivitySubscription;

  Future<void> listenPostUpdates() async {
    _streamFavSubscription = Config.dbInstance
        .collection('users')
        .withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (userItem, options) => userItem.toFirestore(),
        )
        .doc(Config.authInstance.currentUser!.uid)
        .snapshots()
        .asyncMap((event) => event.data()!.favPostsID)
        .listen((event) {
      BottomNavigationTab.favIDListController.favIDList.value = event!;
    });

    _streamPublishedSubscription = Config.dbInstance
        .collection('users')
        .withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (userItem, options) => userItem.toFirestore(),
        )
        .doc(Config.authInstance.currentUser!.uid)
        .snapshots()
        .asyncMap((event) => event.data()!.ownPostsID!.length)
        .listen((event) {
      BottomNavigationTab.favIDListController.publishedNum.value = event;
    });
  }

  Future<void> listenConnectivityStatus() async {
    _streamConnectivitySubscription = widget._flutterNetworkConnectivity
        .getInternetAvailabilityStream()
        .listen((hasInternet) {
      BottomNavigationTab.hasConnection.value = hasInternet;
    });
  }

  @override
  void initState() {
    listenPostUpdates();
    listenConnectivityStatus();
    _pages = <Widget>[HomePage(), ProfilePage()];
    super.initState();
  }

  @override
  void dispose() {
    _streamFavSubscription.cancel();
    _streamPublishedSubscription.cancel();
    _streamConnectivitySubscription.cancel();
    widget._flutterNetworkConnectivity.unregisterAvailabilityListener();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedPageIndex] as Widget,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabItem(
                  index: 0,
                  icon: Icons.home,
                  text: "Home",
                  icon1: Icons.home_outlined),
              InkWell(
                splashColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  BottomNavigationTab.hasConnection.value
                      ? Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: AddEditRecipePage(
                                ctx: context,
                              )))
                      : null;
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Icon(
                    Icons.add,
                    size: MediaQuery.of(context).size.longestSide / 22,
                    color: Colors.white70,
                  ),
                ),
              ),
              buildTabItem(
                  index: 1,
                  icon: Icons.person,
                  text: "Profile",
                  icon1: Icons.person_outline)
            ],
          ),
        ));
  }

  Widget buildTabItem({
    required int index,
    required IconData icon,
    required IconData icon1,
    required String text,
  }) {
    final isSelected = index == _selectedPageIndex;

    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () => _selectPage(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: MediaQuery.of(context).size.longestSide * 0.07,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : icon1,
              color: Colors.grey[500],
              size: MediaQuery.of(context).size.longestSide / 25,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
      ),
    );
  }
}
