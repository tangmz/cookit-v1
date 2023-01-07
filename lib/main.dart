// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cookit_mobile/screens/bottom_navigation_tab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cookit_mobile/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cookit_mobile/screens/auth_page.dart';

import './utils/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookit',
      theme: ThemeData(
        primaryColor: Colors.yellow[700],
      ),
      home: StreamBuilder(
          stream: Config.authInstance.idTokenChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              // return BottomNavigationTab();
              return Scaffold(
                body: Center(
                  child: Text('Loading'),
                ),
              );
            }
            if (userSnapshot.hasData) {
              return BottomNavigationTab();
            }
            return AuthPage();
          }),
    );
  }
}
