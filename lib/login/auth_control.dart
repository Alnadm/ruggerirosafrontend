import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isAuthenticated = false.obs;

  void setAuthenticated(bool value) {
    isAuthenticated.value = value;
  }
}
