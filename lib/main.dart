import 'package:cookit_mobile/screens/add_recipe_page.dart';
import 'package:cookit_mobile/screens/bottom_navigation_tab.dart';
import 'package:cookit_mobile/screens/profile_page.dart';

import './screens/home_page.dart';
import './screens/profile_page.dart';
import './screens/add_recipe_page.dart';
import './widgets/post_grid.dart';
import './screens/bottom_navigation_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookit',
      theme: ThemeData(
        primaryColor: Colors.yellow[700],
      ),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => BottomNavigationTab(),
        // AddRecipePage.routeName: (context) => AddRecipePage(),
        // ProfilePage.routeName: (context) => ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {}),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
