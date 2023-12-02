import 'package:get/get.dart';
import 'package:ruggerifrontend/controller/login_controller.dart';
import 'package:ruggerifrontend/endpoints.dart';
import 'package:http/http.dart' as http;

class FileUploaderController {
  LoginController loginController = Get.put(LoginController());

  Future<http.Response> upload(String fileContent) async {
    return await http.post(Uri.parse(Endpoints().enviaCSV), body: {
      'csv': fileContent
    }, headers: {
      'Authorization': await loginController.getToken(),
    });
  }
}
