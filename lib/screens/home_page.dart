import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../widgets/post_grid.dart';
import '../screens/profile_page.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_body.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home-page';
  const HomePage({super.key});
  final String title = 'Cookit';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(title),
        //   actions: [
        //     IconButton(
        //         onPressed: () => Navigator.of(context).push(
        //             MaterialPageRoute(builder: (context) => ProfilePage())),
        //         icon: Icon(Icons.person))
        //   ],
        // ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: GestureDetector(
                  //==============INSERT SOMETHING HERE==============
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 20, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black12)),
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
                              animatedTexts: [
                                TyperAnimatedText(
                                  "Nasi Lemak",
                                  textStyle: TextStyle(color: Colors.black38),
                                ),
                                TyperAnimatedText(
                                  "Roti Canai",
                                  textStyle: TextStyle(color: Colors.black38),
                                ),
                              ],
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
              // StretchingOverscrollIndicator(
              //     axisDirection: AxisDirection.down, child:
              // PostGrid(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
