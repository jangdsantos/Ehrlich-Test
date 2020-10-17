import 'package:ehrlichtest/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Hello World!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: () {
            Get.find<UserController>().loginAction();
          },
          child: Text('Login'),
        ),
        Text(
          'Please log in to continue',
        ),
      ],
    );
  }
}
