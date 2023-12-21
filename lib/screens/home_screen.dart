import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_auth_getx/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // @override
  // Future<void> initState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     tokenValue = prefs.get('token')!;
  //   });
  //   super.initState();
  // }

  @override
  void initState() {
    Get.put(LoginController());
    // getLoginOps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();
    final tokenValue = loginController;
    print('tokenValue=> ${tokenValue.tokenValue}');
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              prefs.clear();
              Get.offAll(const AuthScreen());
            },
            child: const Text(
              'logout',
              style: TextStyle(color: Colors.white),
            ))
      ]),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome home'),
            TextButton(
                onPressed: () async {
                  final SharedPreferences prefs = await _prefs;
                  print(prefs.get('token'));
                },
                child: const Column(
                  children: [
                    Text('print token'),
                    // tokenValue ? Text(tokenValue) : const Text('print token'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
