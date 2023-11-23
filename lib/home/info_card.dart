import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';
import 'package:http/http.dart' as http;

class InfoListController extends GetxController {
  RxList<RxList<dynamic>> listTokens = <RxList<dynamic>>[].obs;
  RxList<dynamic> listAll = <dynamic>[].obs;
  RxList<dynamic> _selectedTokenLote = <dynamic>[].obs;
  int currentPage = 0;
  int pageSize = 30;
  var isFetching = false.obs;

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
      final response = await http.get(
        Uri.parse(
            'http://localhost:8081/remoto/todos?page=$currentPage&size=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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
    }
  }

  Future<void> fetchOnlyASingleToken(String token) async {
    try {
      isFetching.value = true;
      Map<String, dynamic> requestBody = {
        'token': token,
      };

      final response = await http.post(
        Uri.parse('http://localhost:8081/remoto/token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Recebeu a requisição corretamente");
        List<dynamic> responseObject = jsonDecode(response.body);
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
          DateFormat("dd/MM/yyyy hh:mm").parse(a.first['dataInsercao']);
      DateTime dateB =
          DateFormat("dd/MM/yyyy hh:mm").parse(b.first['dataInsercao']);
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
}
