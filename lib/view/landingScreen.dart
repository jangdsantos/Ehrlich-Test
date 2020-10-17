import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ehrlichtest/controller/userController.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Get.find<UserController>().isBusy.value
            ? CircularProgressIndicator()
            : Get.find<UserController>().user.value.isLoggedIn
                ? HomeScreen()
                : LoginScreen(),
      ),
    );
  }
}
