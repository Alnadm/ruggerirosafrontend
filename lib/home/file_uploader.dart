import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ruggerifrontend/endpoints.dart';
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
            title: const Text(
              'Fazendo o Upload...',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
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
        Uri.parse(Endpoints().enviaCSV),
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
        final Map<String, dynamic> errorBody = json.decode(response.body);
        showErrorDialog('Ehhhh,', 'Não rolou a leitura deste arquivo');
        throw Exception(
          'Failed to upload file. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle exceptions
      showErrorDialog('Eita, ', 'Algum problema aconteceu...');
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
        DottedBorder(
          color: Theme.of(context).textTheme.bodyText1!.color!,
          strokeWidth: 1.5,
          radius: Radius.circular(15),
          dashPattern: [10, 10],
          customPath: (size) {
            return Path()
              ..moveTo(15, 0)
              ..lineTo(size.width - 15, 0)
              ..arcToPoint(Offset(size.width, 15), radius: Radius.circular(15))
              ..lineTo(size.width, size.height - 15)
              ..arcToPoint(Offset(size.width - 15, size.height),
                  radius: Radius.circular(15))
              ..lineTo(15, size.height)
              ..arcToPoint(Offset(0, size.height - 15),
                  radius: Radius.circular(15))
              ..lineTo(0, 15)
              ..arcToPoint(Offset(15, 0), radius: Radius.circular(15));
          },
          child: ElevatedButton(
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
                // side: BorderSide(
                //   color: Theme.of(context).textTheme.bodyText1!.color!,
                //   width: 2.0,
                // ),
              ),
              shadowColor: Colors.transparent,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.38,
              alignment: Alignment.center,
              child: Text(
                'Clique para enviar o Arquivo',
                style: Theme.of(context).textTheme.bodyText1,
              ),
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

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedBorderPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double gapWidth = 5.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
