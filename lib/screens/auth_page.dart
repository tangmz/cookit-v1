import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/config.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _initialMode = 'login';
  File? _selectedImage;

  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) =>
          AlertDialog(content: Text("Choose an image source"), actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Camera"),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              child: Text("Gallery"),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        )
      ]),
    ).then((source) async {
      if (source != null) {
        final pickedFile = await ImagePicker().pickImage(source: source);
        setState(() => _selectedImage = File(pickedFile!.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLogin(
      signUpMode: SignUpModes.both,
      loginTexts: LoginTexts(
          welcomeBack: 'Cookit Mobile',
          welcomeBackDescription: 'Sign-In to your user account',
          notHaveAnAccount: 'Don\'t have an account?',
          signUp: 'Register',
          welcome: 'Cookit Mobile',
          welcomeDescription:
              'Create an account with us and become a Cookit user today!'),
      loginMobileTheme: LoginViewTheme(
          textFormStyle: TextStyle(color: Theme.of(context).hintColor)),
      onAuthModeChange: (authMode) => setState(() {
        _initialMode = authMode.name;
      }),
      logo: _initialMode == 'login'
          ? null
          : InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 18),
                    height: MediaQuery.of(context).size.height * 0.055,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).canvasColor,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.contain)
                          : null,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Add Profile Image",
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).hintColor),
                      ))
                ],
              ),
              onTap: () {
                _pickedImage();
              },
            ),
      validatePassword: false,
      onForgotPassword: (email) async {
        Config.forgotPassword(email, context);
        return null;
      },
      onLogin: (loginData) async {
        Config.login(loginData.email, loginData.password);
        return null;
      },
      onSignup: (signUpData) async {
        Config.register(signUpData.email, signUpData.confirmPassword,
            signUpData.name, _selectedImage, context);
        return null;
      },
    );
  }
}
