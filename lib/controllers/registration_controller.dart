// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_auth_getx/screens/auth/auth_screen.dart';
import 'package:flutter_login_auth_getx/screens/home_screen.dart';
import 'package:flutter_login_auth_getx/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

// To set localstorage
  final Future<SharedPreferences> _prefsLocalStorage =
      SharedPreferences.getInstance();

  Future<void> registrationWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);

      Map formBody = {
        'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(formBody), headers: headers);
      print('response=> $response');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['code'] == 0) {
          var token = jsonData['data']['Token'];
          print('r-token=> $token');
          final SharedPreferences prefsStorage = await _prefsLocalStorage;

          await prefsStorage.setString('token', token);
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(const AuthScreen());
        } else {
          throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}
