import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'dart:developer';

class FileUploader extends StatefulWidget {
  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  String _filePath = '';
  String _fileContent = '';
  late DropzoneViewController controller;

  Future<void> _pickFile() async {
    try {
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
            // If file has bytes directly, use them
            String fileContent = String.fromCharCodes(file.bytes!);

            setState(() {
              _fileContent = fileContent;
            });

            // Call your HTTP endpoint with the file content
            await _uploadFile(fileContent);
          } else {
            // If file.bytes is null, attempt to read the file using dart:io
            File ioFile = File(file.path!);
            List<int> fileBytes = await ioFile.readAsBytes();

            String fileContent = String.fromCharCodes(fileBytes);

            setState(() {
              _fileContent = fileContent;
            });

            // Call your HTTP endpoint with the file content
            await _uploadFile(fileContent);
          }
        } catch (e) {
          print('Error reading file content: $e');
        }
      } else {
        // Handle the case where the user cancels file selection
        log('File selection canceled');
      }
    } on Exception catch (e) {
      log("Erro na leitura do arquivo");
    }
  }

  Future<void> _uploadFile(String fileContent) async {
    try {
      print(fileContent);
      final response = await http.post(
        Uri.parse('http://localhost:8081/remoto'),
        //headers: {'Content-Type': 'application/json'},
        body: {'csv': fileContent},
      );
      if (response.statusCode == 200) {
        // Handle a successful response
        print('File uploaded successfully');
      } else {
        // Handle errors
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading file: $e');
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
          child: Text('Faça o upload do Arquivo de Audiências aqui:',
              style: Theme.of(context).textTheme.bodyText1),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Set background color to transparent
            // onPrimary: Theme.of(context).cardColor, // Set text color
            elevation: 0,
            onPrimary: Colors.transparent,
            primary: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set border radius if needed
              side: BorderSide(
                color: Theme.of(context).cardColor, // Set border color
                width: 2.0, // Set border width
                style: BorderStyle.solid, // Set border style to dashed
              ),
            ),
          ),
          child: Container(
            width: 400,
            height: MediaQuery.of(context).size.height - 570, // Adjust height
            alignment: Alignment.center,
            child: Text(
              'Clique para enviar o CSV',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }

  void onDrop(List<dynamic> ev) async {
    if (ev != null && ev.isNotEmpty) {
      if (ev[0] is PlatformFile) {
        PlatformFile file = ev[0] as PlatformFile;
        await processFile(file);
      } else {
        print('Error: Unexpected type in the event. Please try again.');
      }
    } else {
      print('Error: Event is null or empty. Please try again.');
    }
  }

  Future<void> processFile(PlatformFile file) async {
    try {
      if (file.readStream != null) {
        List<int> fileBytes = [];
        await for (List<int> chunk in file.readStream!) {
          fileBytes.addAll(chunk);
        }

        String fileContent = utf8.decode(fileBytes);

        setState(() {
          _fileContent = fileContent;
        });

        // Call your HTTP endpoint with the file content
        await _uploadFile(fileContent);
      } else {
        print('Error: File read stream is null. Please try again.');
      }
    } catch (e) {
      print('Error reading file content: $e');
    }
  }
}
