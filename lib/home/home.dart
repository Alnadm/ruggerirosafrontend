import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/home/file_uploader.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';
import 'package:ruggerifrontend/theme/theme.dart';

class Home extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.38,
                            height: MediaQuery.of(context).size.height - 500,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                                    child: const InfoCard(
                                        data: '2023-11-18',
                                        quantidadeArquivos: 10,
                                        falhas: 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

class InfoCard extends StatefulWidget {
  final String data;
  final int quantidadeArquivos;
  final int falhas;

  const InfoCard({
    required this.data,
    required this.quantidadeArquivos,
    required this.falhas,
  });

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _colorAnimationController;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) {
        setState(() {
          isHovered = hovering;
          if (isHovered) {
            _colorAnimationController.forward();
          } else {
            _colorAnimationController.reverse();
          }
        });
      },
      onTap: () {
        // Handle onTap if needed
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const BottomModal(
                content: Text(
              'This is the modal content',
              style: TextStyle(fontSize: 24.0),
            ));
          },
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.95),
        );
      },
      child: Card(
        elevation: 0,
        //shadowColor: Colors.transparent,
        //surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: ColorTween(
                        begin: Theme.of(context).cardTheme.color,
                        end: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.3))
                    .animate(_colorAnimationController)
                    .value,
              ),
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data"),
                      Text(
                        widget.data,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Arquivos no Lote:"),
                      Text(
                        '${widget.quantidadeArquivos}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Falhas"),
                      Text(
                        '${widget.falhas}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: [
            InfoCard(
              data: '2023-11-18',
              quantidadeArquivos: 10,
              falhas: 2,
            ),
            InfoCard(
              data: '2023-11-17',
              quantidadeArquivos: 15,
              falhas: 1,
            ),
            InfoCard(
              data: '2023-11-16',
              quantidadeArquivos: 8,
              falhas: 0,
            ),
            // Add more InfoCard widgets as needed
          ],
        ),
      ),
    );
  }
}
