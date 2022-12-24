import 'package:cookit_mobile/screens/add_recipe_page.dart';
import 'package:cookit_mobile/screens/home_page.dart';
import 'package:cookit_mobile/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BottomNavigationTab extends StatefulWidget {
  const BottomNavigationTab({super.key});

  @override
  State<BottomNavigationTab> createState() => _BottomNavigationTabState();
}

class _BottomNavigationTabState extends State<BottomNavigationTab> {
  late List _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = <Widget>[HomePage(), ProfilePage()];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text(_pages[_selectedPageIndex]['title'].toString()),
          // ),
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
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: AddRecipePage()));
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
            // onTap: _selectPage,
            // backgroundColor: Theme.of(context).primaryColor,
            // unselectedItemColor: const Color.fromARGB(133, 255, 255, 255),
            // selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
            // currentIndex: _selectedPageIndex,
            // items: [
            //   BottomNavigationBarItem(
            //     backgroundColor: Theme.of(context).primaryColor,
            //     icon: Icon(Icons.home_outlined),
            //     activeIcon: Icon(Icons.home),
            //     label: 'Home',
            //   ),
            //   BottomNavigationBarItem(
            //     backgroundColor: Theme.of(context).primaryColor,
            //     icon: Icon(Icons.add),
            //     // activeIcon: Icon(Icons.navigation),
            //     label: '',
            //   ),
            //   BottomNavigationBarItem(
            //     backgroundColor: Theme.of(context).primaryColor,
            //     icon: Icon(Icons.person_outline),
            //     activeIcon: Icon(Icons.person),
            //     label: 'Profile',
            //   ),
            // ],
          )),
    );
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
