import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ruggerifrontend/home/modal_bottom.dart';

class FileUploader extends StatefulWidget {
  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  String _filePath = '';
  String _fileContent = '';
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
      print('File selection canceled');
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
        // showModalBottomSheet(
        //   context: context,
        //   isScrollControlled: true,
        //   builder: (BuildContext context) {
        //     return const BottomModal(
        //         content: Text(
        //       'This is the modal content',
        //       style: TextStyle(fontSize: 24.0),
        //     ));
        //   },
        //   constraints: BoxConstraints.expand(
        //       width: MediaQuery.of(context).size.width * 0.80,
        //       height: MediaQuery.of(context).size.height * 0.95),
        //);
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
              shadowColor: Colors.transparent),
          child: Container(
            width: MediaQuery.of(context).size.width - 890, // Adjust width),
            height: MediaQuery.of(context).size.height - 500, // Adjust height
            alignment: Alignment.center,
            child: Text(
              'Clique para enviar o Arquivo',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
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
