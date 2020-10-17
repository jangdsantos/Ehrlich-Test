import 'package:ehrlichtest/controller/navbarController.dart';
import 'package:ehrlichtest/controller/userController.dart';
import 'package:ehrlichtest/view/weatherScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final navbarController = Get.put(NavbarController());

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ehrlich Test'),
          actions: [
            Get.find<UserController>().user.value.isLoggedIn == null || false
                ? FlatButton(
                    onPressed: () {
                      Get.find<UserController>().loginAction();
                    },
                    child: Text('Sign In'))
                : FlatButton(
                    onPressed: () {
                      Get.find<UserController>().logoutAction();
                    },
                    child: Text('Sign Out'))
          ],
        ),
        body: Center(
            child: Text(
          'Hi ${Get.find<UserController>().user.value.userName}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )),
        bottomNavigationBar: GetX<NavbarController>(builder: (controller) {
          return BottomNavigationBar(
            currentIndex: controller.navbarIndex.value,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: Text('Hello')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  title: Text('Home')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.ac_unit,
                  ),
                  title: Text('Weather')),
            ],
            onTap: (index) {
              if(Get.find<UserController>().user.value.isLoggedIn){
                controller.navbarIndex.value = index;
              }
              // if ((Get.find<UserController>().user.value.isLoggedIn == null ||
              //         false) &&
              //     index != 0) {
              //   Fluttertoast.showToast(
              //       msg: "Please log in to continue",
              //       backgroundColor: Colors.black.withOpacity(0.7),
              //       textColor: Colors.white,
              //       gravity: ToastGravity.CENTER);
              // } else {
                

              //   if (Get.find<UserController>().user.value.isLoggedIn && index == 1) {
              //     controller.navbarIndex.value = index;
              //     Get.off(HomeScreen());
              //   } else if (Get.find<UserController>().user.value.isLoggedIn && index == 1) {
              //     controller.navbarIndex.value = index;
              //     Get.off(WeatherScreen());
              //   } 
              // }
            },
          );
        }));
  }
}
