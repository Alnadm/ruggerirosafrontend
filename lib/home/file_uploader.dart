import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ruggerifrontend/home/info_card.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';

class FileUploader extends StatefulWidget {
  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  String _filePath = '';
  String _fileContent = '';
  InfoListController controllerInfoList = Get.put(InfoListController());
  BottomModalController controllerBottomModal = BottomModalController();
  late Future<void> _uploadFileFuture = Future.value(null);

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      setState(() {
        _filePath = file.name!;
      });

      print("File name: $_filePath");

      try {
        if (file.bytes != null) {
          String fileContent = String.fromCharCodes(file.bytes!);
          setState(() {
            _fileContent = fileContent;
          });

          // Call your HTTP endpoint with the file content
          _uploadFileFuture = _uploadFile(fileContent);
        } else {
          File ioFile = File(file.path!);
          List<int> fileBytes = await ioFile.readAsBytes();

          String fileContent = String.fromCharCodes(fileBytes);

          setState(() {
            _fileContent = fileContent;
          });

          // Call your HTTP endpoint with the file content
          _uploadFileFuture = _uploadFile(fileContent);
        }
      } catch (e) {
        print('Error reading file content: $e');
      }
    } else {
      print('File selection canceled');
    }
  }

  Future<void> _uploadFile(String fileContent) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Fazendo o Upload...'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            children: const [
              SizedBox(
                height: 20,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
      );

      final response = await http.post(
        Uri.parse('http://localhost:8081/remoto'),
        body: {'csv': fileContent},
      );

      Navigator.pop(context); // Close the loading indicator dialog

      if (response.statusCode == 200) {
        print('File uploaded successfully');
        final Map<String, dynamic> responseBody = json.decode(response.body);

        print(responseBody['token']);
        //await controllerInfoList.fetchAllComunicados();
        await controllerInfoList
            .getListForTokenRecentlyUpdated(responseBody['token']);
        print("Passamos Fetch GetListForToken");
        controllerBottomModal.controlaModal(
          Get.context!,
          responseBody['token'],
        );
        // Extract the token from the response
        return responseBody['token'];
      } else {
        // Handle errors
        throw Exception(
          'Failed to upload file. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Faça o upload do Arquivo de Audiências aqui:',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            _pickFile();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Theme.of(context).textTheme.bodyText1!.color!,
                width: 2.0,
              ),
            ),
            shadowColor: Colors.transparent,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 890,
            height: MediaQuery.of(context).size.height - 500,
            alignment: Alignment.center,
            child: Text(
              'Clique para enviar o Arquivo',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        // Use FutureBuilder only when needed
        if (_uploadFileFuture != null)
          FutureBuilder(
            future: _uploadFileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              } else {
                // Handle other states as needed
                return SizedBox.shrink();
              }
            },
          ),
      ],
    );
  }
}
