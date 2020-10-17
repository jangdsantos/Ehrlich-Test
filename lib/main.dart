import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/userController.dart';
import 'view/helloScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: HelloScreen());
  }
}
