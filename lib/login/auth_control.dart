import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/controller/login_controller.dart';

class AuthMiddleware extends GetMiddleware {
  Future<void> checkTokenAndNavigate(String? route) async {
    try {
      final LoginController loginController = Get.put(LoginController());
      bool tokenValido = await loginController.validarToken();

      print("Middleware Chamado para autenticação:");
      if (!tokenValido && route != '/login') {
        print("Não autenticado, retorna pra Login");
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print("Erro na autenticação: $e");
      Get.offAllNamed('/login');
    }
  }

  @override
  RouteSettings? redirect(String? route) {
    checkTokenAndNavigate(route);
    return null;
  }
}
