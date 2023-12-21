import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_auth_getx/screens/home_screen.dart';
import 'package:flutter_login_auth_getx/utils/api_endpoints.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  RxString tokenValue = ''.obs;

  dynamic localUser = {}.obs;

  LoginController() {
    _prefs.then((value) {
      print('value.userLoginC=> ${value.getString('userdata')}');
      tokenValue = RxString(value.getString('token') ?? '');
      localUser = jsonDecode(value.getString('userdata') ?? '') ?? {};
    });
  }

  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          final SharedPreferences prefs = await _prefs;
          var userData = json['data'];
          // final user = jsonEncode({'userData': userData});
          final user = jsonEncode(userData);
          print('user=> $user');

          await prefs.setString('userdata', user);
          var token = json['data']['Token'];
          // tokenValue = RxString(token);
          // final SharedPreferences prefs = await _prefs;
          await prefs.setString('token', token);

          emailController.clear();
          passwordController.clear();

          // Wait for SharedPreferences to be updated before navigating
          await Future.delayed(
              const Duration(milliseconds: 500)); // You can adjust the duration

          Get.off(HomeScreen(userDetail: userData));
        } else if (json['code'] == 1) {
          throw jsonDecode(response.body)['message'];
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }

  ///
  /// LOGOUT the User
  /// And Clears the Shared Preference
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userdata');
    await prefs.clear();
  }
}
