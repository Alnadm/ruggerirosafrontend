import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/home/file_uploader.dart';
import 'package:ruggerifrontend/home/info_card.dart';
import 'package:ruggerifrontend/home/info_list_home.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';
import 'package:ruggerifrontend/theme/theme.dart';

class Home extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      body: Row(
        children: [
          // Left-sided Navigation Drawer
          Container(
            margin: const EdgeInsets.all(30.0),
            child: Drawer(
              backgroundColor: Colors.transparent,
              width: 90.0,
              child: Container(
                child: Material(
                  color: Theme.of(context)
                      .drawerTheme
                      .backgroundColor, // Set your desired color here
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0),
                      IconButton(
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Handle your favorite icon tap
                          // Navigator.pop(context); // Close the drawer
                        },
                      ),
                      // Add more IconButton items as needed
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 45, 50, 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      GetBuilder<ThemeController>(
                        builder: (controller) {
                          return IconButton(
                            icon: IconTheme(
                              data: const IconThemeData(
                                  size: 24.0), // Adjust the size as needed
                              child: Get.isDarkMode
                                  ? const Icon(Icons.brightness_2,
                                      color: Colors
                                          .white) // Moon icon for dark mode
                                  : const Icon(Icons.wb_sunny,
                                      color: Colors
                                          .black), // Sun icon for light mode
                            ),
                            onPressed: () => controller.toggleTheme(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      PurpleContainerWithText(
                        color: Theme.of(context).cardColor,
                        borderColor: Colors.transparent,
                        text:
                            "Esse sistema começou a pouco. Sim, ele ainda é uma porcaria",
                        textColor: Colors.white,
                      ),
                      PurpleContainerWithText(
                          color: Theme.of(context).cardTheme.color!,
                          borderColor: Colors.black,
                          text:
                              "Mas a vida é assim mesmo. Começamos devagarzinho, né?",
                          textColor:
                              Theme.of(context).textTheme.bodyText1!.color!),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Divider(
                    color: Color(0xFF93550C),
                    height: 2,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FileUploader(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                            child: Text("Lotes enviados:",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          InfoListHome()
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.38,
                          //   height: MediaQuery.of(context).size.height - 500,
                          //   child: SingleChildScrollView(
                          //     child: Column(
                          //       children: [
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                          //           child: const InfoCard(
                          //               data: '2023-11-18',
                          //               quantidadeArquivos: 10,
                          //               falhas: 2),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _getSwitchValue() {
    if (_themeController.themeMode.value == ThemeMode.system) {
      // If the theme mode is system, determine the switch value based on the platform's brightness preference
      final brightness = MediaQuery.of(Get.context!).platformBrightness;
      return brightness == Brightness.dark;
    } else {
      // If the theme mode is manually set, return the corresponding switch value
      return _themeController.themeMode.value == ThemeMode.dark;
    }
  }
}

class PurpleContainerWithText extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final Color textColor;
  final String text;

  PurpleContainerWithText(
      {required this.color,
      required this.borderColor,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 200,
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
