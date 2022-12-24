import 'package:flutter/material.dart';

import '../widgets/post_grid.dart';
import '../widgets/profile_page_header.dart';

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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfilePageHeader(ctx: context),
            ),
            SliverToBoxAdapter(
              child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "Your Favourites",
                    ),
                    Tab(
                      text: "Your Posts",
                    ),
                  ]),
            ),
            SliverToBoxAdapter(
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Center(
                    child: [
                      PostGrid(),
                      PostGrid(),
                    ][_tabController.index],
                  )),
            )
          ],
        ),
      );
}
