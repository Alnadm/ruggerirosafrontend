import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ruggerifrontend/controller/login_controller.dart';
import 'package:ruggerifrontend/endpoints.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';
import 'package:http/http.dart' as http;
import 'package:ruggerifrontend/login/login.dart';

class InfoListController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  RxList<RxList<dynamic>> listTokens = <RxList<dynamic>>[].obs;
  RxList<dynamic> listAll = <dynamic>[].obs;
  RxList<dynamic> _selectedTokenLote = <dynamic>[].obs;
  int currentPage = 0;
  int pageSize = 100;
  var isFetching = false.obs;
  var uploadAll = false.obs;

  RxList<dynamic> get selectedTokenLote => _selectedTokenLote;

  set selectedTokenLote(RxList<dynamic> value) {
    _selectedTokenLote.value = value;
  }

  InfoListController() {
    fetchAllComunicados();
    //fetchDatatoken("c718a3bf2d19405cab95fad3a446a44b");
  }

  Future<void> fetchAllComunicados() async {
    try {
      isFetching.value = true;
      currentPage = 0;
      listAll.clear();
      listTokens.clear();
      String token = await loginController.getToken();

      final response = await http.get(
        Uri.parse(
            Endpoints().recebeComunicadosPaginacao(currentPage, pageSize)),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> data = json.decode(body);
        final List<dynamic> content = data['content'];

        if (content is List && content.isNotEmpty) {
          listAll.assignAll(content);
          await groupItemsByToken();
          currentPage++;
        } else {
          print('Invalid data format: Expected a non-empty list');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error InfoController All Tokens: $e');
    } finally {
      isFetching.value = false;
      currentPage = 0;
    }
  }

  Future<void> fetchLatestData() async {
    try {
      isFetching.value = true;
      currentPage = 0;
      listAll.clear();
      listTokens.clear();
      await fetchAllComunicados();
      // Optionally, refresh the selected token's data
      if (_selectedTokenLote.isNotEmpty) {
        String currentToken = _selectedTokenLote.first['token'];
        await getListForToken(currentToken);
      }
    } catch (e) {
      print('Error fetching latest data: $e');
      Get.snackbar('Erro', 'Falha ao atualizar os dados.');
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchOnlyASingleToken(String token) async {
    try {
      isFetching.value = true;
      Map<String, dynamic> requestBody = {
        'token': token,
      };

      final response = await http.post(
        Uri.parse(Endpoints().recebeUmComunicado),
        headers: {
          'Authorization': await loginController.getToken(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        List<dynamic> responseObject = jsonDecode(body);
        listAll.addAll(responseObject);
        await addItemByTokenGroup(responseObject.first['token']);
      } else {
        throw Exception('Server returned an error');
      }
    } catch (e) {
      print('Error InfoController Single Token: $e');
    } finally {
      isFetching.value = false;
    }
  }

  int comunicadosPorLote(String token) {
    RxList<dynamic>? tokenGroup = listTokens.firstWhereOrNull(
        (group) => group.isNotEmpty && group.first['token'] == token);

    return tokenGroup?.length ?? 0;
  }

  int comunicadosPorLoteComErro(String token) {
    String targetTag = 'status';
    String targetValue = 'ERRO';

    // Find the token group in listTokens
    RxList<dynamic>? tokenGroup = listTokens.firstWhereOrNull(
        (group) => group.isNotEmpty && group.first['token'] == token);

    // Count items with the specified tag, value, and matching token in the found group
    int count = tokenGroup
            ?.where((item) =>
                item.containsKey(targetTag) &&
                item[targetTag] == targetValue &&
                item['token'] == token)
            .length ??
        0;

    return count;
  }

  Future<void> getListForToken(String token) async {
    RxList<dynamic>? result = listTokens.firstWhereOrNull(
      (tokenList) => tokenList.isNotEmpty && tokenList[0]['token'] == token,
    );

    if (result != null) {
      _selectedTokenLote(
          result); // Assuming _selectedTokenLote is a function/method
    } else {
      // Handle the case where the token is not found
      print('Token $token not found in listTokens');
      // You might want to perform some action or provide a default behavior here
    }
  }

  Future<void> getListForTokenRecentlyUpdated(String token) async {
    // Find the RxList that corresponds to the provided token
    await fetchOnlyASingleToken(token);
    RxList<dynamic>? result = listTokens.firstWhereOrNull(
      (tokenList) => tokenList.isNotEmpty && tokenList[0]['token'] == token,
    );
    if (result != null) {
      _selectedTokenLote(
          result); // Assuming _selectedTokenLote is a function/method
    } else {
      print('Token $token not found in listTokens');
    }
  }

  Future<void> addItemByTokenGroup(String token) async {
    RxList<dynamic> tokenGroup = <dynamic>[].obs;

    listAll.forEach((item) {
      if (item.containsKey('token') && item['token'] == token) {
        tokenGroup.add(item);
      }
    });

    listTokens.add(tokenGroup);
    listTokens.sort((a, b) {
      DateTime dateA =
          DateFormat("dd/MM/yyyy HH:mm").parse(a.first['dataInsercao']);
      DateTime dateB =
          DateFormat("dd/MM/yyyy HH:mm").parse(b.first['dataInsercao']);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> groupItemsByToken() async {
    Map<String, RxList<dynamic>> tokenGroups = {};
    RxList<RxList<dynamic>> newTokenGroups = <RxList<dynamic>>[].obs;

    listAll.forEach((item) {
      if (item.containsKey('token')) {
        String token = item['token'];

        // Create a new RxList for each unique token
        if (!tokenGroups.containsKey(token)) {
          tokenGroups[token] = <dynamic>[].obs;
          newTokenGroups.add(tokenGroups[token]!);
        }

        // Add the item to the corresponding token group
        tokenGroups[token]!.add(item);
      }
    });
    listTokens.addAll(newTokenGroups);
    listTokens.sort((a, b) {
      DateTime dateA =
          DateFormat("dd/MM/yyyy hh:mm").parse(a.first['dataInsercao']);
      DateTime dateB =
          DateFormat("dd/MM/yyyy hh:mm").parse(b.first['dataInsercao']);
      return dateB.compareTo(dateA);
    });
  }

  Future<int> updateAndSendMail(
      {required String email,
      required String name,
      required int comunicadoId,
      required String token}) async {
    try {
      // Implement your API call logic here
      isFetching.value = true;

      Map<String, dynamic> requestBody = {
        'comunicadoId': comunicadoId,
        'token': token,
        'emailSindico': email,
        'nomeSindico': name,
      };

      final response = await http.post(
        Uri.parse(Endpoints().updateComunicado),
        headers: {
          'Authorization': await loginController.getToken(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      return response.statusCode;
      // if (response.statusCode == 200) {
      //   Get.snackbar('Sucesso', 'Email enviado com sucesso.');
      // } else {
      //   Get.snackbar('Erro', 'Falha ao enviar os dados.');
      // }
    } catch (e) {
      print("Excessão identificada no updateAndSendMail");
      return 500;
      // Get.snackbar('Erro', 'Ocorreu um erro: $e');
    }
  }
}
