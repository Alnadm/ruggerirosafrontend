import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:ruggerifrontend/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  logar(String email, String senha) async {
    var url = Uri.parse(Endpoints().autenticaLogin);

    Map<String, dynamic> requestBody = {
      'email': email,
      'password': senha,
    };

    var response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        await armazenaToken(data['token']);

        Get.toNamed("/");
      } else {
        Get.snackbar(
          'Erro',
          'Usuário ou senha incorretos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Problema: $e");
      Get.snackbar(
        'Erro',
        'Problema no Servidor de Login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  logout() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', '');
  }

  Future<bool> validarToken() async {
    String storedToken = await getToken();
    //print(storedToken);
    var url = Uri.parse(Endpoints().validaToken);
    var response = await http.get(
      url,
      headers: {
        'Authorization': storedToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Token válido");
      return true;
    } else {
      print("Token INVÁLIDO: ${response.statusCode}");
      return false;
    }
  }

  armazenaToken(String token) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', 'Bearer $token');
  }

  Future<String> getToken() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    if (_sharedPreferences.getString('token').isNull) {
      return "";
    } else {
      return _sharedPreferences.getString('token')!;
    }
  }
}
