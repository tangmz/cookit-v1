import 'package:cookit_mobile/screens/add_recipe_step.dart';
import 'package:cookit_mobile/screens/add_recipe_summ.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddRecipePage extends StatefulWidget {
  static const routeName = '/add-recipe-page';
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    Get.delete<MyCardList>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
          title: Text("Post a New Recipe")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                  controller: _pageController,
                  children: [AddRecipeSumm(), AddRecipeStep()]),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: _pageController,
                effect: ScaleEffect(
                    dotColor: (Colors.grey[500])!,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 10),
                // layout: PageIndicatorLayout.SCALE,
                // color: Colors.grey[500],
                // activeColor: Theme.of(context).primaryColor,
                // size: 15,
                // activeSize: 20,
                // space: 5,
                count: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
