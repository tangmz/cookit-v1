// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/config.dart';
import '../widgets/profile_page_header.dart';
import '../widgets/profile_page_fav.dart';
import '../widgets/profile_page_post.dart';
import 'bottom_navigation_tab.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile-page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollConfiguration(
          behavior: ScrollGlowBehaviour(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: ProfilePageHeader(ctx: context),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: kToolbarHeight - 8.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 5.0,
                              color: Theme.of(context).primaryColor),
                          insets: EdgeInsets.symmetric(horizontal: 30)),
                      tabs: [
                        Tab(
                          text: "Your Favourites",
                        ),
                        Tab(
                          text: "Your Posts",
                        ),
                      ]),
                ),
              ),
              Obx(
                () => BottomNavigationTab.hasConnection.value
                    ? SliverToBoxAdapter(
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: Center(
                              child: [
                                ProfilePageFav(),
                                ProfilePagePost()
                              ][_tabController.index],
                            )),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child:
                              Image.asset('assets/images/Connection_Lost.png'),
                        ),
                      ),
              )
            ],
          ),
        ),
      );
}
