import 'package:flutter/material.dart';
import 'package:flutter_login_auth_getx/controllers/login_controller.dart';
import 'package:flutter_login_auth_getx/screens/auth/auth_screen.dart';
import 'package:flutter_login_auth_getx/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

// var newTokenValue = ''.obs;

// Function to load token from shared preferences
Future<void> loadTokenFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  // newTokenValue.value = prefs.getString('token') ?? '';
  prefs.getString('token') ?? '';
}

void main() async {
  // Initialize GetX bindings.
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of LoginController
  // final loginController = Get.put(LoginController());
  Get.put(LoginController());

  // Load the token from shared preferences
  await loadTokenFromStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the LoginController and get the tokenValue.
    final LoginController loginController = Get.find();
    final tokenData = loginController;
    print('tokenValue-main=> ${tokenData.tokenValue}');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Auth Getx',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Obx(() {
        print('main.tokenData.tokenValue=> ${tokenData.tokenValue}');
        return tokenData.tokenValue.isNotEmpty
            ? const HomeScreen()
            : const AuthScreen();
      }),
    );
  }
}
